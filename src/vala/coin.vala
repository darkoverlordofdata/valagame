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
        public Vector2 Size;
        public Texture2D Sprite;
        public SpriteBatch Sprites;

        public extern void free();

        /** 
         * Register the Coin class type 
         */
        public static int Type { get { return Entity.Register("Coin", sizeof(Coin)); } }

        /** 
         * Register handlers for creating and destroying Coin types 
         */
        public static void Register() { Entity.Handler(Type, Create, free); }

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
            Position = Vector2.Zero;
            Sprite = Game.Instance.Content.Load<Texture2D>("tiles/coin.dds");
            Size = Vector2(Sprite.Width, Sprite.Height);
            Sprites = ((Platformer)Game.Instance).Sprites;
        }
        
        public void Render(Vector2 camera) 
        {
            Sprites.Draw(Sprite, camera, Color.White);
            
            // GL.PushState(camera);
            // GL.BindTexture(GL_TEXTURE_2D, Sprite.Handle);
            // GL.Draw(Position, Size);
            // GL.PopState();
        }
    }
}