namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class BackgroundTemplate : Object, IEntityTemplate 
    {
        const string name = "background";
        static Shmupwarz game = EntitySystem.BlackBoard.GetEntry<Shmupwarz>("game");

        /**
         * Build a background
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
            var sprite = new Sprite(name, 1);

            sprite.X = (float)game.Width/sprite.Region.Width;
            sprite.Y = (float)game.Height/sprite.Region.Height;

            position.X = sprite.X*sprite.Region.Width/2;
            position.Y = sprite.Y*sprite.Region.Height/2;

            return entity
                .AddComponent(new Background())
                .AddComponent(position)
                .AddComponent(sprite);
        }
    }
}
