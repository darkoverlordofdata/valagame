using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;

/**
 * Player Component
 */
namespace Demo 
{

    [Compact, CCode (ref_function = "", unref_function = "")]
    public class Character 
    {
        public Vector2 Velocity;
        public Vector2 Position;
        public float FlapTimer;
        public bool FacingLeft;

        public extern void free();

        /** Register the Character class type */
        public static int Type { get { return Component.Register("Character", sizeof(Character)); } }
        /** Register handlers for creating and destroying Character types */
        public static void Register() { Entity.Handler(Type, Create, free); }

        public static Character Get(string name) 
        {
            return (Character)Entity(name, Type);
        }
    

        /** Character factory method */
        public static Component Create() 
        {
            var character = new Character();
            character.Position = Vector2.Zero;
            character.Velocity = Vector2.Zero;
            character.FlapTimer = 0;
            character.FacingLeft = false;
            return (Component)character;
        }

        public string ToString() 
        {
            return "Character(%f,%f)".printf(Velocity.X, Velocity.Y);
        }

        public void Update() 
        {
            Velocity.X = clamp(Velocity.X, -7.0f, 7.0f);
            Position = Position.Add(Velocity);
            
            if (FlapTimer > 0.0) {
                FlapTimer -= (float)Loop.Time();
            }
        }

        public void Render(Vector2 camera) 
        {
            GL.Prolog(camera);
            
            /* Conditional as to if we render flap or normal icon */
            GL.BindTexture(GL_TEXTURE_2D, 
                FlapTimer > 0.0 
                    ? Texture.gl("Content/tiles/character_flap.dds")
                    : Texture.gl("Content/tiles/character.dds"));

            /* Swaps the direction of the uvs when facing the opposite direction */
            if (FacingLeft) 
            {
                GL.Begin(GL_TRIANGLES);
                GL.TexCoord2f(1, 1); GL.Vertex3f(Position.X, Position.Y + 32, 0);
                GL.TexCoord2f(1, 0); GL.Vertex3f(Position.X, Position.Y, 0);
                GL.TexCoord2f(0, 0); GL.Vertex3f(Position.X + 32, Position.Y, 0);
                
                GL.TexCoord2f(1, 1); GL.Vertex3f(Position.X, Position.Y + 32, 0);
                GL.TexCoord2f(0, 1); GL.Vertex3f(Position.X + 32, Position.Y + 32, 0);
                GL.TexCoord2f(0, 0); GL.Vertex3f(Position.X + 32, Position.Y, 0);
                GL.End();
            } 
            else 
            {
                GL.Begin(GL_TRIANGLES);
                GL.TexCoord2f(0, 1); GL.Vertex3f(Position.X, Position.Y + 32, 0);
                GL.TexCoord2f(0, 0); GL.Vertex3f(Position.X, Position.Y, 0);
                GL.TexCoord2f(1, 0); GL.Vertex3f(Position.X + 32, Position.Y, 0);
                
                GL.TexCoord2f(0, 1); GL.Vertex3f(Position.X, Position.Y + 32, 0);
                GL.TexCoord2f(1, 1); GL.Vertex3f(Position.X + 32, Position.Y + 32, 0);
                GL.TexCoord2f(1, 0); GL.Vertex3f(Position.X + 32, Position.Y, 0);
                GL.End();
            }
            GL.Epilog();
        }
    }
}