namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class PlayerTemplate : Object, IEntityTemplate 
    {
        const string name = "spaceshipspr";

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
            var sprite = new Sprite(name, 0.1f, 0.8f, 0.8f);
            
            return entity
                .AddComponent(new Player())
                .AddComponent(new Position())
                .AddComponent(sprite)
                .AddComponent(new Bounds(sprite));
        }
    }
}