using System;
using Microsoft.Xna.Framework;

namespace Microsoft.Xna.Framework.Graphics 
{
    /*  0,1  1,1
     *  TL    TR
     *   0----1 0,1,2,3 = index offsets for vertex indices
     *   |   /| TL,TR,BL,BR are vertex references in SpriteBatchItem.
     *   |  / |
     *   | /  |
     *   |/   |
     *   2----3
     *  BL    BR
     *  0,0   1,0
     */

    public class VertexBatchItem : Object
    {
        private const Vector2 UnitY = { 0, 1 };
        private const Vector2 UnitX = { 1, 0 };
        
        public Texture2D Texture;
        public float SortKey;
        // Triangle 1
        public VertexPositionColorTexture Vertex1TR;
        public VertexPositionColorTexture Vertex1TL;
        public VertexPositionColorTexture Vertex1BL;
        // Triangle 2
        public VertexPositionColorTexture Vertex2TR;
        public VertexPositionColorTexture Vertex2BR;
        public VertexPositionColorTexture Vertex2BL;
        
        public void Set(
            float x, 
            float y, 
            float w, 
            float h, 
            Color? color=null, 
            Vector2? texCoordTL=null, 
            Vector2? texCoordBR=null,
            float depth=0)
        {
            color = color ?? Color.White;
            texCoordTL = texCoordTL ?? UnitY;
            texCoordBR = texCoordBR ?? UnitX;
            // TR { 1, 1 }
            Vertex1TR.Position.X = x + w;
            Vertex1TR.Position.Y = y;
            Vertex1TR.Position.Z = depth;
            Vertex1TR.Color = color;
            Vertex1TR.TextureCoordinate.X = texCoordBR.X;
            Vertex1TR.TextureCoordinate.Y = texCoordTL.Y;
            // TL { 0, 1 }
            Vertex1TL.Position.X = x;
            Vertex1TL.Position.Y = y;
            Vertex1TL.Position.Z = depth;
            Vertex1TL.Color = color;
            Vertex1TL.TextureCoordinate.X = texCoordTL.X;
            Vertex1TL.TextureCoordinate.Y = texCoordTL.Y;
            // BL { 0, 0 }
            Vertex1BL.Position.X = x;
            Vertex1BL.Position.Y = y + h;
            Vertex1BL.Position.Z = depth;
            Vertex1BL.Color = color;
            Vertex1BL.TextureCoordinate.X = texCoordTL.X;
            Vertex1BL.TextureCoordinate.Y = texCoordBR.Y;
            // TR { 1, 1 }
            Vertex2TR.Position.X = x + w;
            Vertex2TR.Position.Y = y;
            Vertex2TR.Position.Z = depth;
            Vertex2TR.Color = color;
            Vertex2TR.TextureCoordinate.X = texCoordBR.X;
            Vertex2TR.TextureCoordinate.Y = texCoordTL.Y;
            // BR { 1, 0 }
            Vertex2BR.Position.X = x + w;
            Vertex2BR.Position.Y = y + h;
            Vertex2BR.Position.Z = depth;
            Vertex2BR.Color = color;
            Vertex2BR.TextureCoordinate.X = texCoordBR.X;
            Vertex2BR.TextureCoordinate.Y = texCoordBR.Y;
            // BL { 0, 0 }
            Vertex2BL.Position.X = x;
            Vertex2BL.Position.Y = y + h;
            Vertex2BL.Position.Z = depth;
            Vertex2BL.Color = color;
            Vertex2BL.TextureCoordinate.X = texCoordTL.X;
            Vertex2BL.TextureCoordinate.Y = texCoordBR.Y;

        }
    }
}