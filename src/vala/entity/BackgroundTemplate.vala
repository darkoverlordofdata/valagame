namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class BackgroundTemplate : EntityTemplate 
    {
        const string name = "background";
        static Shmupwarz game = EntitySystem.BlackBoard.GetEntry<Shmupwarz>("game");

        /**
         * Build a background
         * @entity the newly created entity
         * @world the world context
         * @param the vararg parameters
         */
        public override Artemis.Entity BuildEntity(
            Artemis.Entity entity, 
            World world, 
            va_list param = null)
        {
            var position = new Position();
            var sprite = new Sprite(name, 1);

            print("game (%d,%d) - sprite (%f,%f)\n", game.Width, game.Height, sprite.Region.Width, sprite.Region.Height);

            const float factor = 1.17f;
            // sprite.X = 1.57f;
            sprite.X = factor * (float)game.Width/sprite.Region.Width;
            sprite.Y = factor;//(float)game.Height/sprite.Region.Height;

            position.X = 0;//sprite.X*sprite.Region.Width/2;
            position.Y = 0;//sprite.Y*sprite.Region.Height/2;

            print("Background (%f,%f)(%f,%f)\n", sprite.X, sprite.Y, position.X, position.Y);

            return entity
                .AddComponent(new Background())
                .AddComponent(position)
                .AddComponent(sprite);
        }
    }
}
