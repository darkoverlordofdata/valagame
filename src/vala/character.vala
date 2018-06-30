using ValaGame.OpenGL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
/**
 * Player Component
 */
namespace Demo 
{

    [SimpleStruct]
    public struct VertexData2D
    {
        public Vector2 Position;
        public Vector2 TexCoord;
        public VertexData2D(float u, float v, float w, float h)
        {
            TexCoord = Vector2(u, v);
            Position = Vector2(w, h);
        }
    }

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
        public uint CharacterVbo;
        public uint CharacterIbo;
        public VertexData2D Data[6];
        public const uint[] Index = { 0, 1, 2, 3, 4, 5 };

        public extern void free();

        /** 
         * Register the Character class type 
         */
        public static int Type { get { return Entity.Register("Character", sizeof(Character)); } }
        /** 
         * Register handlers for creating and destroying Character types 
         */
        public static void Register() { Entity.Handler(Type, Create, Dispose); }
        

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

            //Create VBO
            GL.GenBuffers( 1, &CharacterVbo );
            GL.BindBuffer( BufferTarget.ArrayBuffer, CharacterVbo );
            GL.BufferData( BufferTarget.ArrayBuffer, 6 * sizeof(VertexData2D), Data, BufferUsageHint.StreamDraw );

            //Create IBO
            GL.GenBuffers( 1, &CharacterIbo );
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, CharacterIbo );
            GL.BufferData( BufferTarget.ElementArrayBuffer, 6 * sizeof(uint), Index, BufferUsageHint.StreamDraw );

            //Unbind buffer
            GL.BindBuffer( BufferTarget.ArrayBuffer, 0 );
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, 0 );
       }

        public void Update() 
        {
            Velocity.X = MathHelper.Clampf(Velocity.X, -7.0f, 7.0f);
            Position = Position.Add(Velocity);
            if (FlapTimer > 0.0) 
            {
                FlapTimer -= (float)Game.Instance.Time;
            }
            if (FacingLeft)
            {
                Data[0] = VertexData2D(1, 1, Position.X ,         Position.Y+Size.Y);
                Data[1] = VertexData2D(1, 0, Position.X ,         Position.Y);
                Data[2] = VertexData2D(0, 0, Position.X+Size.X ,  Position.Y);

                Data[3] = VertexData2D(1, 1, Position.X ,         Position.Y+Size.Y);
                Data[4] = VertexData2D(0, 1, Position.X+Size.X ,  Position.Y+Size.Y);
                Data[5] = VertexData2D(0, 0, Position.X+Size.X ,  Position.Y);
            } 
            else
            {
                Data[0] = VertexData2D(0, 1, Position.X ,         Position.Y+Size.Y);
                Data[1] = VertexData2D(0, 0, Position.X ,         Position.Y);
                Data[2] = VertexData2D(1, 0, Position.X+Size.X ,  Position.Y);

                Data[3] = VertexData2D(0, 1, Position.X ,         Position.Y+Size.Y);
                Data[4] = VertexData2D(1, 1, Position.X+Size.X ,  Position.Y+Size.Y);
                Data[5] = VertexData2D(1, 0, Position.X+Size.X ,  Position.Y);
            }
        }

        public void Render(Vector2 camera) 
        {
            GL.Use2DCamera(camera);
            GL.BindTexture(TextureTarget.Texture2D, Sprite[FlapTimer > 0.0 ? 0 : 1].Handle);

            //Enable vertex and texture coordinate arrays
            GL.EnableClientState( EnableCap.VertexArray );
            GL.EnableClientState( EnableCap.TextureCoordArray );

            //Bind vertex buffer
            GL.BindBuffer( BufferTarget.ArrayBuffer, CharacterVbo );
            
            //Update vertex buffer data
            GL.BufferSubData( BufferTarget.ArrayBuffer, 0, 6 * sizeof(VertexData2D), Data );

            //Set texture coordinate data
            GL.TexCoordPointer( 2, DataType.Float, (int)sizeof(VertexData2D), (void*)8 );

            //Set vertex data
            GL.VertexPointer( 2, DataType.Float, (int)sizeof(VertexData2D), (void*)0 );

            //Draw quad using vertex data and index data
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, CharacterIbo );
            GL.DrawElements( PrimitiveType.Triangles, 6, DataType.UnsignedInt, null );

            //Disable vertex and texture coordinate arrays
            GL.DisableClientState( EnableCap.TextureCoordArray );
            GL.DisableClientState( EnableCap.VertexArray );

            GL.End();
        }

        public string ToString() 
        {
            return "Character(%f,%f)".printf(Velocity.X, Velocity.Y);
        }

        public void Dispose()
        {
            //Free VBO and IBO
            if( CharacterVbo != 0 )
            {
                GL.DeleteBuffers( 1, &CharacterVbo );
                GL.DeleteBuffers( 1, &CharacterIbo );
            }
        }
    }
}