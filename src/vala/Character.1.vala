using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

/**
 * Player Component
 */
namespace Demo 
{
    [Compact, CCode (ref_function = "", unref_function = "")]
    public class Character 
    {
        public Vector2? Velocity;
        public Vector2? Position;
        public Vector2? Size;
        public float FlapTimer;
        public bool FacingLeft;
        public Texture2D[] Sprite;
        public SpriteBatch? Batch;

        public extern void free();

        /** 
         * Register the Character class type 
         */
        public static int Type { get { return Entity.Register("Character", sizeof(Character)); } }
        /** 
         * Register handlers for creating and destroying Character types 
         */
        public static void Register() { Entity.Handler(Type, Create, free); }

        public static Character Get(string name) 
        {
            return (Character)Entity(name, Type);
        }

        public static Entity Create() 
        {
            return (Entity) new Character();
        }

        public Character()
        {
            Size = Vector2(32, 32);
            Position = Vector2.Zero;
            Velocity = Vector2.Zero;
            FlapTimer = 0;
            FacingLeft = false;
            Sprite = {
                Game.Instance.Content.Load<Texture2D>("tiles/character.dds"),
                Game.Instance.Content.Load<Texture2D>("tiles/character_flap.dds")
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
            // if (Batch == null) Batch = new VertexBatch(Sprite, Position);
            
            if (FlapTimer > 0.0) {
                FlapTimer -= (float)Game.Instance.Time;
            }
        }

        public void Render(Vector2 camera) 
        {
            GL.PushState(camera);
            GL.BindTexture(TextureTarget.Texture2D, Sprite[FlapTimer > 0.0 ? 0 : 1].Handle);
            GL.Draw(Position, Size, FacingLeft);
            GL.PopState();
        }
    }
}