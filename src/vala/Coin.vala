using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
/**
 * Coin Component
 */
namespace Demo 
{
    public class Coin : Object, IDisposable
    {
        public Vector2? Position;
        public Texture2D? Sprite;

        /** 
         * Register the Coin Entity 
         */
        public static void Register() { Entity.Handler(Type, Create, Dispose); }
        public static int Type { get { return Entity.Register("Coin", sizeof(Coin)); } }
        public static int Count { get { return Entity.Count(Type); } }

        /**
         * Coin Factory
         */
        private static Object Create() 
        {
            return new Coin();
        }

        private Coin()
        {
            Sprite = Game.Instance.Content.Load<Texture2D>("tiles/coin.dds");
        }

        /** 
         * Returns the name of this Coin 
         */
        public string Name { get { return Entity.Name(this); } }

        /** 
         * Trigger deletion of this Coin 
         */
        public void Remove() { Entity.Delete(Name); }

        public void Initialize(Vector2 position)
        {
            Position = position;
        }

        public void Draw(SpriteBatch spriteBatch) 
        {
            spriteBatch.Draw0(Sprite, Position);
        }

        public void Dispose() 
        {
        }
    }
}