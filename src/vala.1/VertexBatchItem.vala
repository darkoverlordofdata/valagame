using GL;
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
        const Vector2 UnitY = { 0, 1 };
        const Vector2 UnitX = { 1, 0 };
        
        public Texture2D Texture;
        public float SortKey;
        // Triangle 1
        public VertexPositionColorTexture vertex1TR;
        public VertexPositionColorTexture vertex1TL;
        public VertexPositionColorTexture vertex1BL;
        // Triangle 2
        public VertexPositionColorTexture vertex2TR;
        public VertexPositionColorTexture vertex2BR;
        public VertexPositionColorTexture vertex2BL;
        
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
            vertex1TR.Position.X = x + w;
            vertex1TR.Position.Y = y;
            vertex1TR.Position.Z = depth;
            vertex1TR.Color = color;
            vertex1TR.TextureCoordinate.X = texCoordBR.X;
            vertex1TR.TextureCoordinate.Y = texCoordTL.Y;
            // TL { 0, 1 }
            vertex1TL.Position.X = x;
            vertex1TL.Position.Y = y;
            vertex1TL.Position.Z = depth;
            vertex1TL.Color = color;
            vertex1TL.TextureCoordinate.X = texCoordTL.X;
            vertex1TL.TextureCoordinate.Y = texCoordTL.Y;
            // BL { 0, 0 }
            vertex1BL.Position.X = x;
            vertex1BL.Position.Y = y + h;
            vertex1BL.Position.Z = depth;
            vertex1BL.Color = color;
            vertex1BL.TextureCoordinate.X = texCoordTL.X;
            vertex1BL.TextureCoordinate.Y = texCoordBR.Y;
            // TR { 1, 1 }
            vertex2TR.Position.X = x + w;
            vertex2TR.Position.Y = y;
            vertex2TR.Position.Z = depth;
            vertex2TR.Color = color;
            vertex2TR.TextureCoordinate.X = texCoordBR.X;
            vertex2TR.TextureCoordinate.Y = texCoordTL.Y;
            // BR { 1, 0 }
            vertex2BR.Position.X = x + w;
            vertex2BR.Position.Y = y + h;
            vertex2BR.Position.Z = depth;
            vertex2BR.Color = color;
            vertex2BR.TextureCoordinate.X = texCoordBR.X;
            vertex2BR.TextureCoordinate.Y = texCoordBR.Y;
            // BL { 0, 0 }
            vertex2BL.Position.X = x;
            vertex2BL.Position.Y = y + h;
            vertex2BL.Position.Z = depth;
            vertex2BL.Color = color;
            vertex2BL.TextureCoordinate.X = texCoordTL.X;
            vertex2BL.TextureCoordinate.Y = texCoordBR.Y;

        }
    }
}