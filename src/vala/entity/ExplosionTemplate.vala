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
            var x = param.arg<int>();
            var y = param.arg<int>();
            var scale = param.arg<float?>(); // pointer to float

            return entity
                .AddComponent(new Position(x, y))
                .AddComponent(new Sprite(name, 0.2f, scale, scale, 1, 216/255f, 0, 0.5f))
                .AddComponent(new Expires(0.1f))
                .AddComponent(new ScaleAnimation(scale/100f, scale, -3f, false, true));
        }
    }
}