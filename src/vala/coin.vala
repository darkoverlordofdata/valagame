using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;

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
        public GL.GLuint Sprite;

        public extern void free();

        // /** Register the Coin class type */
        public static int Type { get { return Component.Register("Coin", sizeof(Coin)); } }
        // /** Register handlers for creating and destroying Coin types */
        public static void Register() { Entity.Handler(Type, Create, free); }
        /** Returns the number of Coins */
        public static int Count { get { return Entity.Count(Type); } }
        /** Returns the name of this Coin */
        public string Name { get { return Entity.Name(this); } }
        /** Trigger deletion of this Coin */
        public void Remove() { Entity.Delete(Name); }

        /** Coin factory method */
        public static Component Create() 
        {
            return (Component) new Coin();
        }

        public Coin()
        {
            Size = Vector2(32, 32);
            Position = Vector2.Zero;
            Sprite = Texture.GL("Content/tiles/coin.dds");
        }
        
        public void Render(Vector2 camera) 
        {
            GL.Prolog(camera);
            GL.BindTexture(GL_TEXTURE_2D, Sprite);
            GL.Draw(Position, Size);
            GL.Epilog();
        }
    }
}