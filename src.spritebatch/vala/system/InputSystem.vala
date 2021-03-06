namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class InputSystem : EntityProcessingSystem
    {
        private Game game;
        private bool shoot;
        private float timeToFire;
	    private const float FireRate = 0.1f;
        private ComponentMapper<Position> positions;

        public InputSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({ typeof(Player) }));
            this.game = game;
        }

        protected override void Initialize()
        {
            positions = World.GetMapper<Position>();
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var position = positions[e];
            
            position.X = game.Window.MouseState.X;
            position.Y = game.Window.MouseState.Y;

            var keyboardState = Keyboard.GetState();
            if (keyboardState.IsKeyDown(Keys.Escape))   { game.Exit(); }
            if (keyboardState.IsKeyDown(Keys.Z))        { shoot = true; }
            if (keyboardState.IsKeyUp(Keys.Z))          { shoot = false; }

            if(shoot) 
            {
                if(timeToFire <= 0) 
                {
                    var x = (int)position.X;
                    var y = (int)position.Y;
                    World.CreateEntityFromTemplate("bullet", x-27, y+2).AddToWorld();
                    World.CreateEntityFromTemplate("bullet", x+27, y+2).AddToWorld();

                    timeToFire = FireRate;
                }
            }
            if(timeToFire > 0)
            {
                timeToFire -= World.delta;
                if(timeToFire < 0) 
                {
                    timeToFire = 0;
                }
            }

        }
    }
}