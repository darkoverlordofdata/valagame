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
        const float PI = 3.14159f;
        static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");
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
 
            var position = new Position();
            position.xy = param.arg<Vector2?>();

            var sprite = new Sprite();
            sprite.name = name;
            sprite.region = atlas.Region(name);
            sprite.scale = { 0.8f, 0.8f };
            sprite.r = 1;
            sprite.g = 216/255f;
            sprite.b = 0;
            sprite.a = 1f;
            sprite.depth = 0.1f;

            float radians = (float)game.Random.next_double()*2*PI;
            float magnitude = (float)game.Random.next_double()*400f;

            var velocity = new Velocity();
            velocity.xy = { Math.cosf(radians), Math.sinf(radians) };

            var expires = new Expires();
            expires.delay = 1f;

            var colorAnimation = new ColorAnimation();
            colorAnimation.alphaAnimate = true;
            colorAnimation.alphaSpeed = -1f;
            colorAnimation.alphaMin = 0f;
            colorAnimation.alphaMax = 1f;
            colorAnimation.repeat = false;

            return entity
                .AddComponent(new Bullet())
                .AddComponent(position)
                .AddComponent(sprite)
                .AddComponent(velocity)
                .AddComponent(expires)
                .AddComponent(colorAnimation);

        }
    }
}