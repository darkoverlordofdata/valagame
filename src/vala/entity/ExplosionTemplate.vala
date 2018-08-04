namespace Demo 
{
    using Artemis;
    using Artemis.Managers;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class ExplosionTemplate : Object, IEntityTemplate 
    {
        const string name = "explosion";
        static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");

        /**
         * Build an explosion
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

            var scale = param.arg<Vector2?>();

            var sprite = new Sprite();
            sprite.name = name;
            sprite.region = atlas.Region(name);
            sprite.scale = { scale.X, scale.Y };
            sprite.r = 1;
            sprite.g = 216/255f;
            sprite.b = 0;
            sprite.a = 0.5f;
            sprite.depth = 0.1f;

            var expires = new Expires();
            expires.delay = 0.5f;

            var scaleAnimation = new ScaleAnimation();
            scaleAnimation.active = true;
            scaleAnimation.max = scale.X;
            scaleAnimation.min = scale.X/100f;
            scaleAnimation.speed = -3.0f;
            scaleAnimation.repeat = false;

            return entity
                .AddComponent(new Bullet())
                .AddComponent(position)
                .AddComponent(sprite)
                .AddComponent(expires)
                .AddComponent(scaleAnimation);

        }
    }
}