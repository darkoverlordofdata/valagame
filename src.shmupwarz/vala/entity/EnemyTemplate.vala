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
            var x = param.arg<int>();
            var y = param.arg<int>();
            var speed = param.arg<int>();
            var image = @"$name%d".printf(index);

            var sprite = new Sprite(image, 0.2f + points/100, 0.8f, 0.8f);

		    world.GetManager<GroupManager>().Add(entity, name);

            return entity
                .AddComponent(new Enemy())
                .AddComponent(new Position(x, y))
                .AddComponent(sprite)
                .AddComponent(new Velocity(0, speed))
                .AddComponent(new Bounds(sprite))
                .AddComponent(new Health(points));
        }
    }
}