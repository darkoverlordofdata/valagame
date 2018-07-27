namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class RenderSystem : EntityProcessingSystem
    {
        private ComponentMapper<ScaleComponent> scaleMapper;
        private ComponentMapper<SpriteComponent> spriteMapper;
        private ComponentMapper<PositionComponent> positionMapper;
        private SpriteBatch spriteBatch;
        private GraphicsDeviceManager graphics;
        private OrthoCamera camera;

        public RenderSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({ typeof(SpriteComponent) }));
        }

        protected override void Initialize()
        {
            scaleMapper = World.GetMapper<ScaleComponent>();
            spriteMapper = World.GetMapper<SpriteComponent>();
            positionMapper = World.GetMapper<PositionComponent>();
            spriteBatch = EntitySystem.BlackBoard.GetEntry<SpriteBatch>("SpriteBatch");
            graphics = EntitySystem.BlackBoard.GetEntry<GraphicsDeviceManager>("GraphicsDeviceManager");
            camera = EntitySystem.BlackBoard.GetEntry<OrthoCamera>("OrthoCamera");
        }

        protected override void Begin()
        {
            graphics.GraphicsDevice.Clear(Color.CadetBlue);
            spriteBatch.Begin(camera);
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var scale = scaleMapper[e];
            var sprite = spriteMapper[e];
            var position = positionMapper[e];

            if (position == null)
            {
                spriteBatch.Draw(sprite.region, null, scale.scale);
            }
            else
            {
                spriteBatch.Draw(sprite.region, position.point, scale.scale);
            }

        }
        
        protected override void End()
        {
            spriteBatch.End();
        }
    }
}