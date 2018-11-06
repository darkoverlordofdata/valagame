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
            spriteBatch = BlackBoard.GetEntry<SpriteBatch>("SpriteBatch");
            graphics = BlackBoard.GetEntry<GraphicsDeviceManager>("GraphicsDeviceManager");
            camera = BlackBoard.GetEntry<OrthoCamera>("OrthoCamera");
        }

        protected override void Begin()
        {
            graphics.GraphicsDevice.Clear(Color.CadetBlue);
            // graphics.GraphicsDevice.Clear(Color.Red);
            spriteBatch.Begin();
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var sprite = sprites[e];
            var region = sprite.Region;
            var layerDepth = -sprite.Depth;
            var position = sprite.Centered ? new Vector2(positions[e].X, positions[e].Y) : null;
            var scale = new Vector2(sprite.X, sprite.Y);
            var color = new Color.Rgbaf(sprite.R, sprite.G, sprite.B, sprite.A);

            spriteBatch.DrawRegion(region, layerDepth, position, scale, color);
        }
        
        protected override void End()
        {
            spriteBatch.End();
        }
    }
}