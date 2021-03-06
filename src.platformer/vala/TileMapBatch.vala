using System.Collections.Generic;
using Microsoft.Xna.Framework;

namespace Microsoft.Xna.Framework.Graphics 
{
    public interface ITileMap : Object
    {
        // Gets the path for tile index
        public abstract Dictionary<int, string> Path { get; }
        // returns the count of different tiles
        public abstract int Count { get; }
        // returns the count for a specific tile
        public abstract int CountOf(int tile);
        // returns the tile at x,y
        public abstract int At(int x, int y);
        // Gets the path for tile index
        public abstract string ToString(int tile);
        // Check if tile index has collision
        public abstract bool HasCollision(int tile);
    }

    public class TileMapBatch : Object
    {
        public int countPositions;
        public int countTexCoords;
        public int sizeOfPositions;
        public int sizeOfTexCoords;
        public int[] tileCount;
        public float[] Positions;
        public float[] TexCoords;
        public uint[] PositionsBuffer;
        public uint[] TexcoordsBuffer;
        public Texture2D?[] Texture;
        /*
         *  TL    TR
         *   0----1 0,1,2,3 = index offsets for vertex indices
         *   |   /| TL,TR,BL,BR are vertex references in SpriteBatchItem.
         *   |  / |
         *   | /  |
         *   |/   |
         *   2----3
         *  BL    BR
         */
        protected static short[,,] Coord = {
            {   // Normal
                // TR        TL        BL        TR        BR        BL
                { 0, 1 }, { 0, 0 }, { 1, 0 }, { 0, 1 }, { 1, 1 }, { 1, 0 }
            },
            {   // Inverted
                // BR        BL        TL        BR        TR        TL
                { 1, 1 }, { 1, 0 }, { 0, 0 }, { 1, 1 }, { 0, 1 }, { 0, 0 }
            }
        };            

        public TileMapBatch(Texture2D texture, Vector2? position = null, int size=1, int flip = 0)
        {
            // var texSize = 2 * 6 * size;
            // var posSize = 3 * 6 * size;

            // var pos = position ?? Vector2.Zero;
            // Texture = texture;
            // TexCoords = new float[texSize];
            // Positions = new float[posSize];
            // countTexCoords = 0;
            // countPositions = 0;
            // sizeOfPositions = (int)sizeof(float) * posSize;
            // sizeOfTexCoords = (int)sizeof(float) * texSize;

            // for (var i=0; i<6; i++) // Generate 6 pts. for 2 triangles
            // {
            //     AddPosition(pos.X + (Coord[flip,i,0] * texture.Width), 
            //                 pos.Y + (Coord[flip,i,1] * texture.Height), 
            //                 0);

            //     AddTexCoord(Coord[flip,i,0], 
            //                 Coord[flip,i,1]); 
            // }

            // Bind();
            
        }

        public void AddTexCoord(float x, float y)
        {
            // TexCoords[countTexCoords++] = x;
            // TexCoords[countTexCoords++] = y;
        }
        
        public void AddPosition(float x, float y, float z)
        {
            // Positions[countPositions++] = x;
            // Positions[countPositions++] = y;
            // Positions[countPositions++] = z;
        }

        public void SetPosition(float x=0, float y=0, float z=0, int flip=0)
        {
            // Positions = new float[3*6];
            // countPositions = 0;
            // for (var i=0; i<6; i++) // Generate 6 pts. for 2 triangles
            // {
            //     AddPosition(x + (Coord[flip,i,0] * Texture.Width), 
            //                 y + (Coord[flip,i,1] * Texture.Height), 0);
            // }
            
        }

        public void Bind()
        {
            // GL.GenBuffers(1, &PositionsBuffer);
            // GL.GenBuffers(1, &TexcoordsBuffer);
            
            // GL.BindBuffer(GL_ARRAY_BUFFER, PositionsBuffer);
            // GL.BufferData(GL_ARRAY_BUFFER, sizeOfPositions, Positions, GL_STATIC_DRAW);
            
            // GL.BindBuffer(GL_ARRAY_BUFFER, TexcoordsBuffer);
            // GL.BufferData(GL_ARRAY_BUFFER, sizeOfTexCoords, TexCoords, GL_STATIC_DRAW);
            
            // GL.BindBuffer(GL_ARRAY_BUFFER, 0);
        }

        public void Draw(Vector2? camera=null)
        {
            // GL.Use2DCamera(camera);
            // GL.BindTexture(GL_TEXTURE_2D, Texture.Handle);
            // GL.DrawUserArrays(1, PositionsBuffer, TexcoordsBuffer);
            // // GL.PopState();
        }

        public void Dispose() 
        {
            // GL.DeleteBuffers(1 , &PositionsBuffer);
            // GL.DeleteBuffers(1 , &TexcoordsBuffer);
        }
    }
}