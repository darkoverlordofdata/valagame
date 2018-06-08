using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

/**
 * Coin Component
 */
namespace Demo 
{
    [Compact, CCode (ref_function = "", unref_function = "")]
    public class Coin  
    {
        public Vector2 Position;
        public Texture2D Sprite;
        public VertexBatch Batch;

        public extern void free();

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

        public void SetPosition(Vector2 positions)
        {
            Position = positions;
            Batch = new VertexBatch(Sprite, Position);
        }

        public void Render(Vector2 camera) 
        {
            Batch.Draw(camera);
        }

        public void Dispose() 
        {
            Batch.Dispose();
            free();
        }
    }
}