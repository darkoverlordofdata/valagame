namespace Demo 
{
    using Artemis;
    using Artemis.Managers;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class EnemyTemplate : Object, IEntityTemplate 
    {
        const string name = "enemy";
        static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");

        /**
         * Build a enemy
         * @entity the newly created entity
         * @world the world context
         * @param the vararg parameters
         */
        public Artemis.Entity BuildEntity(
            Artemis.Entity entity, 
            World world, 
            va_list param = null)
        {
            var index = param.arg<int>();
            var points = param.arg<int>();
            var pos = param.arg<Vector2?>();
            var vel = param.arg<Vector2?>();

            var position = new Position();
            position.xy = pos;

            var sprite = new Sprite();
            sprite.name = name;
            sprite.region = atlas.Region(@"$name%d".printf(index));
            sprite.depth = 0.2f + points/100;
            sprite.scale = { 0.8f, 0.8f };

            var velocity = new Velocity();
            velocity.xy = vel;

            var bounds = new Bounds();
            bounds.xy = sprite.scale.Mul({ sprite.region.Width, sprite.region.Height });

            var health = new Health();
            health.points = points;
            health.max = points;

		    world.GetManager<GroupManager>().Add(entity, name);

            return entity
                .AddComponent(new Enemy())
                .AddComponent(position)
                .AddComponent(sprite)
                .AddComponent(velocity)
                .AddComponent(bounds)
                .AddComponent(health);
        }
    }
}