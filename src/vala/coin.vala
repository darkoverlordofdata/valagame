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
            var coin = new Coin();
            coin.Position = Vector2.Zero;
            return (Component)coin;
        }

        public void Render(Vector2 camera) 
        {
            GL.Prolog(camera);
            GL.BindTexture(GL_TEXTURE_2D, Texture.gl("Content/tiles/coin.dds"));
            GL.Begin(GL_QUADS);
            
            GL.TexCoord2f(0, 1); GL.Vertex3f(Position.X, Position.Y + 32, 0);
            GL.TexCoord2f(1, 1); GL.Vertex3f(Position.X + 32, Position.Y + 32, 0);
            GL.TexCoord2f(1, 0); GL.Vertex3f(Position.X + 32, Position.Y, 0);
            GL.TexCoord2f(0, 0); GL.Vertex3f(Position.X, Position.Y, 0);
            
            GL.End();
            GL.Epilog();
        }
    }
}