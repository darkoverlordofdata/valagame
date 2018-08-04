namespace Demo 
{
    using Artemis;
    using Artemis.Managers;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class BulletTemplate : Object, IEntityTemplate 
    {
        const string name = "bullet";
        static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");

        /**
         * Build a bullet
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
            position.xy = param.arg<Vector2?>();

            var sprite = new Sprite();
            sprite.name = name;
            sprite.region = atlas.Region(name);
            sprite.depth = 0.1f;
            sprite.scale = { 0.8f, 0.8f };

            var velocity = new Velocity();
            velocity.xy = { 0, -800 };

            var bounds = new Bounds();
            bounds.xy = sprite.scale.Mul({ sprite.region.Width, sprite.region.Height });

            var expires = new Expires();
            expires.delay = 0.1f;

		    world.GetManager<GroupManager>().Add(entity, name);

            return entity
                .AddComponent(new Bullet())
                .AddComponent(position)
                .AddComponent(sprite)
                .AddComponent(velocity)
                .AddComponent(bounds)
                .AddComponent(expires);

        }
    }
}