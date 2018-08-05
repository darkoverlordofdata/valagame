namespace Demo 
{
    using Artemis;
    using Artemis.Managers;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class ParticleTemplate : Object, IEntityTemplate 
    {
        const string name = "particle";
        const float TAUf = 2 * (float)Math.PI;
        static Shmupwarz game = EntitySystem.BlackBoard.GetEntry<Shmupwarz>("game");

        /**
         * Build a particle
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
 
            var scale = (float)game.Random.next_double();
            var radians = (float)game.Random.next_double() * TAUf;
            var magnitude = (float)game.Random.next_double() * 400f;
            var velocityX = magnitude * Math.cosf(radians);
            var velocityY = magnitude * Math.sinf(radians);

            return entity
                .AddComponent(new Position(x, y))
                .AddComponent(new Sprite("star", 0.1f, scale, scale, 1, 216/255f, 0, 1))
                .AddComponent(new Velocity(velocityX, velocityY))
                .AddComponent(new Expires(0.25f))
                .AddComponent(new ColorAnimation(0f, 1f, -1f, true, false));

        }
    }
}