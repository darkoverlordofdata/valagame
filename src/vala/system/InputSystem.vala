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
            var position = game.Window.MouseState.Position.ToVector2();
            positions[e].xy = position;

            var keyboardState = Keyboard.GetState();
            if (keyboardState.IsKeyDown(Keys.Escape))   { game.Exit(); }
            if (keyboardState.IsKeyDown(Keys.Z))        { shoot = true; }
            if (keyboardState.IsKeyUp(Keys.Z))          { shoot = false; }

            if(shoot) 
            {
                if(timeToFire <= 0) 
                {
                    // We need a ref to a struct to pass to template
                    Vector2? gunLeft  = position.Add({ -27, 2 });
                    Vector2? gunRight = position.Add({  27, 2 });

                    World.CreateEntityFromTemplate("bullet", gunLeft).AddToWorld();
                    World.CreateEntityFromTemplate("bullet", gunRight).AddToWorld();

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