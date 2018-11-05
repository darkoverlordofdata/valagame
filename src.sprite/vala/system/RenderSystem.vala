namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class RenderSystem : EntityProcessingSystem
    {
        ComponentMapper<Sprite> sprites;
        ComponentMapper<Position> positions;
        SpriteRenderer renderer;
        GraphicsDeviceManager graphics;

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
            graphics = BlackBoard.GetEntry<GraphicsDeviceManager>("GraphicsDeviceManager");
            renderer = BlackBoard.GetEntry<SpriteRenderer>("Renderer");
        }

        protected override void Begin()
        {
            // graphics.GraphicsDevice.Clear(Color.CadetBlue);
            graphics.GraphicsDevice.Clear(Color.Red);
            renderer.Begin(SpriteSortMode.BackToFront);
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var sprite = sprites[e];
            var region = sprite.Region;
            var w = region.Width;
            var h = region.Height;
            var scale = new Vector2(sprite.X, sprite.Y);
            var layerDepth = sprite.Depth;
            var color = new Color.Rgbaf(sprite.R, sprite.G, sprite.B, sprite.A);
            var position = sprite.Centered
                ? new Vector2(positions[e].X-((w*scale.X)/2), positions[e].Y-((h*scale.Y)/2))
                : new Vector2(1, 1);

            renderer.Draw(region, layerDepth, position, scale, color);
        }
        
        protected override void End()
        {
            renderer.End();
        }
    }
}