namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class BackgroundTemplate : Object, IEntityTemplate 
    {
        const string name = "background";
        static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");

        /**
         * Build a background
         * @entity the newly created entity
         * @world the world context
         * @param the vararg parameters
         */
        public Artemis.Entity BuildEntity(
            Artemis.Entity entity, 
            World world, 
            va_list param = null)
        {
            var position = new Position();
            position.xy = null;
            
            var size = param.arg<Vector2>();
            
            var sprite = new Sprite();
            sprite.name = name;
            sprite.region = atlas.Region(name);
            sprite.scale = size.Div(sprite.region.Size.ToVector2());
            sprite.depth = 1.0f;

            return entity
                .AddComponent(new Background())
                .AddComponent(position)
                .AddComponent(sprite);
        }
    }
}
