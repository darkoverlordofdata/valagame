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
            var region = sprite.Region;
            var scale = Vector2(sprite.X, sprite.Y);
            var layerDepth = sprite.Depth;
            var color = new Color.Rgbaf(sprite.R, sprite.G, sprite.B, sprite.A);
            Vector2 position = { positions[e].X, positions[e].Y };

            spriteBatch.Draw(region, layerDepth, position, scale, color);
        }
        
        protected override void End()
        {
            spriteBatch.End();
        }
    }
}