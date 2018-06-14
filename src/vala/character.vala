using ValaGame.OpenGL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
/**
 * Player Component
 */
namespace Demo 
{

    [SimpleType]
    public struct VertexData2D
    {
        public Vector2 position;
        public Vector2 texCoord;
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
        public uint vboId;
        public uint iboId;

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

            VertexData2D[] vData = new VertexData2D[6];
            uint[] iData = { 0, 1, 2, 3, 4, 5 };

            //Create VBO
            GL.GenBuffers( 1, &vboId );
            GL.BindBuffer( BufferTarget.ArrayBuffer, vboId );
            GL.BufferData( BufferTarget.ArrayBuffer, 6 * sizeof(VertexData2D), vData, ValaGame.OpenGL.BufferUsageHint.StreamDraw );

            //Create IBO
            GL.GenBuffers( 1, &iboId );
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, iboId );
            GL.BufferData( BufferTarget.ElementArrayBuffer, 6 * sizeof(uint), iData, ValaGame.OpenGL.BufferUsageHint.StreamDraw );

            //Unbind buffers
            GL.BindBuffer( BufferTarget.ArrayBuffer, 0 );
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, 0 );

        }

        public void Dispose()
        {
            //Free VBO and IBO
            if( vboId != 0 )
            {
                GL.DeleteBuffers( 1, &vboId );
                GL.DeleteBuffers( 1, &iboId );
            }

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

            //Set vertex data
            VertexData2D vData[ 6 ];

            //Texture coordinates
            if (FacingLeft)
            {
                //Texture coordinates
                vData[ 0 ].texCoord.X = 1; vData[ 0 ].texCoord.Y = 1;
                vData[ 1 ].texCoord.X = 1; vData[ 1 ].texCoord.Y = 0;
                vData[ 2 ].texCoord.X = 0; vData[ 2 ].texCoord.Y = 0;
                vData[ 3 ].texCoord.X = 1; vData[ 3 ].texCoord.Y = 1;
                vData[ 4 ].texCoord.X = 0; vData[ 4 ].texCoord.Y = 1;
                vData[ 5 ].texCoord.X = 0; vData[ 5 ].texCoord.Y = 0;
            }
            else
            {
                vData[ 0 ].texCoord.X = 0; vData[ 0 ].texCoord.Y = 1;
                vData[ 1 ].texCoord.X = 0; vData[ 1 ].texCoord.Y = 0;
                vData[ 2 ].texCoord.X = 1; vData[ 2 ].texCoord.Y = 0;
                vData[ 3 ].texCoord.X = 0; vData[ 3 ].texCoord.Y = 1;
                vData[ 4 ].texCoord.X = 1; vData[ 4 ].texCoord.Y = 1;
                vData[ 5 ].texCoord.X = 1; vData[ 5 ].texCoord.Y = 0;
            }
            //Vertex positions
            vData[ 0 ].position.X = Position.X; 
            vData[ 0 ].position.Y = Position.Y+Size.Y;

            vData[ 1 ].position.X = Position.X; 
            vData[ 1 ].position.Y = Position.Y;

            vData[ 2 ].position.X = Position.X+Size.X; 
            vData[ 2 ].position.Y = Position.Y;

            vData[ 3 ].position.X = Position.X; 
            vData[ 3 ].position.Y = Position.Y+Size.Y;

            vData[ 4 ].position.X = Position.X+Size.X; 
            vData[ 4 ].position.Y = Position.Y+Size.Y;

            vData[ 5 ].position.X = Position.X+Size.X; 
            vData[ 5 ].position.Y = Position.Y;

            GL.BindTexture(TextureTarget.Texture2D, Sprite[FlapTimer > 0.0 ? 0 : 1].Handle);

            //Enable vertex and texture coordinate arrays
            GL.EnableClientState( EnableCap.VertexArray );
            GL.EnableClientState( EnableCap.TextureCoordArray );

            //Bind vertex buffer
            GL.BindBuffer( BufferTarget.ArrayBuffer, vboId );
            
            //Update vertex buffer data
            // GL.BufferSubData( BufferTarget.ArrayBuffer, 0, 6 * sizeof(VertexData2D), vData );
            GL.BufferSubData( BufferTarget.ArrayBuffer, 0, 6 * sizeof(VertexData2D), vData );

            //Set texture coordinate data
            GL.TexCoordPointer( 2, DataType.Float, (int)sizeof(VertexData2D), (void*)8 );

            //Set vertex data
            GL.VertexPointer( 2, DataType.Float, (int)sizeof(VertexData2D), (void*)0 );

            //Draw quad using vertex data and index data
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, iboId );
            GL.DrawElements( PrimitiveType.Triangles, 6, DataType.UnsignedInt, null );

            //Disable vertex and texture coordinate arrays
            GL.DisableClientState( EnableCap.TextureCoordArray );
            GL.DisableClientState( EnableCap.VertexArray );

            GL.End();

            GL.PopState();
        }
    }
}