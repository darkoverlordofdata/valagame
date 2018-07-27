namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class InputSystem : EntityProcessingSystem
    {
        private ComponentMapper<PositionComponent> positionMapper;
        private Game game;

        public InputSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({ typeof(PlayerComponent) }));
            this.game = game;
        }

        protected override void Initialize()
        {
            positionMapper = World.GetMapper<PositionComponent>();
        }

        public void ProcessEachz(Artemis.Entity e)
        {
            ProcessEach(e);
        }
        protected override void ProcessEach(Artemis.Entity e)
        {
            var position = positionMapper[e];
            position.point.X = game.Window.MouseState.X;
            position.point.Y = game.Window.MouseState.Y;

            var keyboardState = Keyboard.GetState();
            if (keyboardState.IsKeyDown(Keys.Escape))   { game.Exit(); }
            if (keyboardState.IsKeyDown(Keys.Z))        { Fire(); }
        }

        public void Fire()
        {
            print("Fire!\n");
        }

    }
}