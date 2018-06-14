using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
/**
 * Player Component
 */
namespace Demo 
{
    [SimpleType]
    public struct TexCoord2D
    {
        public float s;
        public float t;
    }
    [SimpleType]
    public struct VertexPos2D
    {
        public float x;
        public float y;
    }
    [SimpleType]
    public struct VertexData2D
    {
        public VertexPos2D position;
        public TexCoord2D texCoord;
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
        public GLuint mVBOID;
        public GLuint mIBOID;
        // public delegate void BufferSubDataDelegate (BufferTarget target, int offset, int size, void *data);
        // public BufferSubDataDelegate BufferSubData = (BufferSubDataDelegate)Sdl.SDL_GL_GetProcAddress("glBufferSubData");

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
            GLuint[] iData = { 0, 1, 2, 3, 4, 5 };
            // GLuint[] iData = { 0, 1, 3, 1, 2, 3 };

            
            //Create VBO
            GL.GenBuffers( 1, &mVBOID );
            GL.BindBuffer( BufferTarget.ArrayBuffer, mVBOID );
            GL.BufferData( BufferTarget.ArrayBuffer, 6 * sizeof(VertexData2D), vData, BufferUsageHint.DynamicDraw );

            //Create IBO
            GL.GenBuffers( 1, &mIBOID );
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, mIBOID );
            GL.BufferData( BufferTarget.ElementArrayBuffer, 6 * sizeof(GLuint), iData, BufferUsageHint.DynamicDraw );

            //Unbind buffers
            GL.BindBuffer( BufferTarget.ArrayBuffer, 0 );
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, 0 );

        }

        public void Dispose()
        {
            //Free VBO and IBO
            if( mVBOID != 0 )
            {
                GL.DeleteBuffers( 1, &mVBOID );
                GL.DeleteBuffers( 1, &mIBOID );
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
                vData[ 0 ].texCoord.s = 1; vData[ 0 ].texCoord.t = 1;
                vData[ 1 ].texCoord.s = 1; vData[ 1 ].texCoord.t = 0;
                vData[ 2 ].texCoord.s = 0; vData[ 2 ].texCoord.t = 0;
                vData[ 3 ].texCoord.s = 1; vData[ 3 ].texCoord.t = 1;
                vData[ 4 ].texCoord.s = 0; vData[ 4 ].texCoord.t = 1;
                vData[ 5 ].texCoord.s = 0; vData[ 5 ].texCoord.t = 0;
            }
            else
            {
                vData[ 0 ].texCoord.s = 0; vData[ 0 ].texCoord.t = 1;
                vData[ 1 ].texCoord.s = 0; vData[ 1 ].texCoord.t = 0;
                vData[ 2 ].texCoord.s = 1; vData[ 2 ].texCoord.t = 0;
                vData[ 3 ].texCoord.s = 0; vData[ 3 ].texCoord.t = 1;
                vData[ 4 ].texCoord.s = 1; vData[ 4 ].texCoord.t = 1;
                vData[ 5 ].texCoord.s = 1; vData[ 5 ].texCoord.t = 0;
            }
            //Vertex positions
            vData[ 0 ].position.x = Position.X; 
            vData[ 0 ].position.y = Position.Y+Size.Y;

            vData[ 1 ].position.x = Position.X; 
            vData[ 1 ].position.y = Position.Y;

            vData[ 2 ].position.x = Position.X+Size.X; 
            vData[ 2 ].position.y = Position.Y;

            vData[ 3 ].position.x = Position.X; 
            vData[ 3 ].position.y = Position.Y+Size.Y;

            vData[ 4 ].position.x = Position.X+Size.X; 
            vData[ 4 ].position.y = Position.Y+Size.Y;

            vData[ 5 ].position.x = Position.X+Size.X; 
            vData[ 5 ].position.y = Position.Y;

            GL.BindTexture(TextureTarget.Texture2D, Sprite[FlapTimer > 0.0 ? 0 : 1].Handle);

            //Enable vertex and texture coordinate arrays
            GL.EnableClientState( EnableCap.VertexArray );
            GL.EnableClientState( EnableCap.TextureCoordArray );

            //Bind vertex buffer
            GL.BindBuffer( BufferTarget.ArrayBuffer, mVBOID );
            
            //Update vertex buffer data
            // GL.BufferSubData( BufferTarget.ArrayBuffer, 0, 6 * sizeof(VertexData2D), vData );
            GL.BufferSubData( BufferTarget.ArrayBuffer, 0, 6 * sizeof(VertexData2D), vData );

            //Set texture coordinate data
            GL.TexCoordPointer( 2, DataType.Float, (GLsizei)sizeof(VertexData2D), (GLvoid*)8 );

            //Set vertex data
            GL.VertexPointer( 2, DataType.Float, (GLsizei)sizeof(VertexData2D), (GLvoid*)0 );

            //Draw quad using vertex data and index data
            GL.BindBuffer( BufferTarget.ElementArrayBuffer, mIBOID );
            GL.DrawElements( GL.PrimitiveType.Triangles, 6, DataType.UnsignedInt, null );

            //Disable vertex and texture coordinate arrays
            GL.DisableClientState( EnableCap.TextureCoordArray );
            GL.DisableClientState( EnableCap.VertexArray );

            GL.End();

            GL.PopState();
        }
    }
}