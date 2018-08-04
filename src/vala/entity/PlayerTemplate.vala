namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class PlayerTemplate : Object, IEntityTemplate 
    {
        const string name = "spaceshipspr";
        static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");

        /**
         * Build a player
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
            position.xy = { 0, 0 };

            var sprite = new Sprite();
            sprite.name = name;
            sprite.region = atlas.Region(name);
            sprite.depth = 0.1f;
            sprite.scale = { 0.8f, 0.8f };

            var bounds = new Bounds();
            bounds.xy = sprite.scale.Mul({ sprite.region.Width, sprite.region.Height });

            return entity
                .AddComponent(new Player())
                .AddComponent(position)
                .AddComponent(sprite)
                .AddComponent(bounds);
        }
    }
}