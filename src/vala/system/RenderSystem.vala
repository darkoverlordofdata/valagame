namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class RenderSystem : EntityProcessingSystem
    {
        private ComponentMapper<Sprite> sprites;
        private ComponentMapper<Position> positions;
        private SpriteBatch spriteBatch;
        private GraphicsDeviceManager graphics;
        private OrthoCamera camera;

        public RenderSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({
                    typeof(Sprite), 
                    typeof(Position) 
            }));
        }

        protected override void Initialize()
        {
            sprites = World.GetMapper<Sprite>();
            positions = World.GetMapper<Position>();
            spriteBatch = EntitySystem.BlackBoard.GetEntry<SpriteBatch>("SpriteBatch");
            graphics = EntitySystem.BlackBoard.GetEntry<GraphicsDeviceManager>("GraphicsDeviceManager");
            camera = EntitySystem.BlackBoard.GetEntry<OrthoCamera>("OrthoCamera");

        }

        protected override void Begin()
        {
            graphics.GraphicsDevice.Clear(Color.CadetBlue);
            spriteBatch.Begin(camera, SpriteSortMode.BackToFront);
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var sprite = sprites[e];
            var region = sprite.region;
            var scale = sprite.scale;
            var layerDepth = sprite.depth;
            var color = new Color.Rgbaf(sprite.r, sprite.g, sprite.b, sprite.a);
            var position = positions[e].xy;

            spriteBatch.Draw(region, layerDepth, position, scale, color);
        }
        
        protected override void End()
        {
            spriteBatch.End();
        }
    }
}