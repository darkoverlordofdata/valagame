using GL1;
using System;
using Microsoft.Xna.Framework;

namespace Microsoft.Xna.Framework.Graphics 
{
    public class StaticBatch : Object, IDisposable
    {
        // int countPositions;
        // int countTexCoords;
        // float[] Positions;
        // float[] TexCoords;
        uint PositionsBuffer;
        uint TexcoordsBuffer;
        Texture2D? Texture;
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

        public StaticBatch(Texture2D texture, Vector2? position = null, int size=1, int flip = 0)
        {
            var pos = position ?? Vector2.Zero;
            Texture = texture;
            var TexCoords = new float[12];
            var Positions = new float[18];
            var countTexCoords = 0;
            var countPositions = 0;

            for (var i=0; i<6; i++) // Generate 6 pts. for 2 triangles
            {

                Positions[countPositions++] = pos.X + (Coord[flip,i,0] * texture.Width);
                Positions[countPositions++] = pos.Y + (Coord[flip,i,1] * texture.Height);
                Positions[countPositions++] = 0;

                TexCoords[countTexCoords++] = Coord[flip,i,0]; 
                TexCoords[countTexCoords++] = Coord[flip,i,1]; 
            }


            GL1.GenBuffers(1, &PositionsBuffer);
            GL1.GenBuffers(1, &TexcoordsBuffer);
            
            GL1.BindBuffer(BufferTarget.ArrayBuffer, PositionsBuffer);
            GL1.BufferData(BufferTarget.ArrayBuffer, Positions.length*sizeof(float), Positions, GL_STATIC_DRAW);
            
            GL1.BindBuffer(BufferTarget.ArrayBuffer, TexcoordsBuffer);
            GL1.BufferData(BufferTarget.ArrayBuffer, TexCoords.length*sizeof(float), TexCoords, GL_STATIC_DRAW);
            
            GL1.BindBuffer(BufferTarget.ArrayBuffer, 0);
        }

        public void Draw(Vector2? camera=null)
        {
            GL1.PushState(camera);
            GL1.BindTexture(TextureTarget.Texture2D, Texture.Handle);
            GL1.DrawUserArrays(1, PositionsBuffer, TexcoordsBuffer);
            GL1.PopState();
        }

        public void Dispose() 
        {
            GL1.DeleteBuffers(1 , &PositionsBuffer);
            GL1.DeleteBuffers(1 , &TexcoordsBuffer);
        }

    }
    

}