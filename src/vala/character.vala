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
        public Vector2 Size;
        public float FlapTimer;
        public bool FacingLeft;
        public GL.GLuint[] Sprite;

        public extern void free();

        /** Register the Character class type */
        public static int Type { get { return Component.Register("Character", sizeof(Character)); } }
        /** Register handlers for creating and destroying Character types */
        public static void Register() { Entity.Handler(Type, Create, free); }

        public static Character Get(string name) 
        {
            return (Character)Entity(name, Type);
        }

        public static Component Create() 
        {
            return (Component) new Character();
        }

        public Character()
        {
            Size = Vector2(32, 32);
            Position = Vector2.Zero;
            Velocity = Vector2.Zero;
            FlapTimer = 0;
            FacingLeft = false;
            Sprite = {
                Texture.GL("Content/tiles/character.dds"),
                Texture.GL("Content/tiles/character_flap.dds")
            };
        }

        public string ToString() 
        {
            return "Character(%f,%f)".printf(Velocity.X, Velocity.Y);
        }

        public void Update() 
        {
            Velocity.X = MathHelper.Clampf(Velocity.X, -7.0f, 7.0f);
            Position = Position.Add(Velocity);
            if (FlapTimer > 0.0) {
                FlapTimer -= (float)Corange.Time;
            }
        }

        public void Render(Vector2 camera) 
        {
            GL.Prolog(camera);
            GL.BindTexture(GL_TEXTURE_2D, Sprite[FlapTimer > 0.0 ? 0 : 1]);
            GL.Draw(Position, Size, FacingLeft);
            GL.Epilog();
        }
    }
}