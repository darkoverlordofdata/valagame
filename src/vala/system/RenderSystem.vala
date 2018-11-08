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
        SpriteBatch2D spriteBatch;
        GraphicsDeviceManager graphics;
        Matrix projection;

        public RenderSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({
                    typeof(Sprite), 
                    typeof(Position) 
            }));
            projection = new Matrix();
            glm_ortho(0f, (float)game.Width, (float)game.Height, 0f, -1f, 1f, projection);
        }

        protected override void Initialize()
        {
            sprites = World.GetMapper<Sprite>();
            positions = World.GetMapper<Position>();
            spriteBatch = BlackBoard.GetEntry<SpriteBatch2D>("SpriteBatch");
            graphics = BlackBoard.GetEntry<GraphicsDeviceManager>("GraphicsDeviceManager");
        }

        protected override void Begin()
        {
            graphics.GraphicsDevice.Clear(Color.CadetBlue);
            spriteBatch.Begin(SpriteSortMode.FrontToBack);//, projection);
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var sprite = sprites[e];
            var region = sprite.Region;
            var layerDepth = sprite.Depth;
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