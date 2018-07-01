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
        public Vector2 Position;
        public Texture2D Sprite;

        /** 
         * Register the Coin class type 
         */
        public static int Type { get { return Entity.Register("Coin", sizeof(Coin)); } }

        /** 
         * Register handlers for creating and destroying Coin types 
         */
        public static void Register() { Entity.Handler(Type, Create, Dispose); }

        /** 
         * Returns the number of Coins 
         */
        public static int Count { get { return Entity.Count(Type); } }

        /** 
         * Returns the name of this Coin 
         */
        public string Name { get { return Entity.Name(this); } }

        /** 
         * Trigger deletion of this Coin 
         */
        public void Remove() { Entity.Delete(Name); }

        /**
         * Create a Coin Entity
         */
        public static Entity Create() 
        {
            return (Entity) new Coin();
        }

        public Coin()
        {
            Sprite = Game.Instance.Content.Load<Texture2D>("tiles/coin.dds");
        }

        public void Initialize(Vector2 position)
        {
            Position = position;
        }

        public void Draw(VertexBatch spriteBatch) 
        {
            spriteBatch.Draw(Sprite, Position);
        }

        public void Dispose() 
        {
        }
    }
}