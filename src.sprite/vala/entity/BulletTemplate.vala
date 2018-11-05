namespace Demo 
{
    using Artemis;
    using Artemis.Managers;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class BulletTemplate : EntityTemplate 
    {
        const string name = "bullet";

        /**
         * Build a bullet
         * @entity the newly created entity
         * @world the world context
         * @param the vararg parameters
         */
        public override Artemis.Entity BuildEntity(
            Artemis.Entity entity, 
            World world, 
            va_list param = null)
        {
            var x = param.arg<int>();
            var y = param.arg<int>();

            var sprite = new Sprite(name, 0.1f, 0.8f, 0.8f);

		    world.GetManager<GroupManager>().Add(entity, name);

            return entity
                .AddComponent(new Bullet())
                .AddComponent(new Position(x, y))
                .AddComponent(sprite)
                .AddComponent(new Velocity(0, -800))
                .AddComponent(new Bounds(sprite))
                .AddComponent(new Expires(0.1f));
        }
    }
}