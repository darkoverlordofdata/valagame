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
        public VertexPositionColorTexture vertex11;
        public VertexPositionColorTexture vertex12;
        public VertexPositionColorTexture vertex13;
        // Triangle 2
        public VertexPositionColorTexture vertex21;
        public VertexPositionColorTexture vertex22;
        public VertexPositionColorTexture vertex23;
        
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
            vertex11.Position.X = x + w;
            vertex11.Position.Y = y;
            vertex11.Position.Z = depth;
            vertex11.Color = color;
            vertex11.TextureCoordinate.X = texCoordBR.X;
            vertex11.TextureCoordinate.Y = texCoordTL.Y;
            // TL { 0, 1 }
            vertex12.Position.X = x;
            vertex12.Position.Y = y;
            vertex12.Position.Z = depth;
            vertex12.Color = color;
            vertex12.TextureCoordinate.X = texCoordTL.X;
            vertex12.TextureCoordinate.Y = texCoordTL.Y;
            // BL { 0, 0 }
            vertex13.Position.X = x;
            vertex13.Position.Y = y + h;
            vertex13.Position.Z = depth;
            vertex13.Color = color;
            vertex13.TextureCoordinate.X = texCoordTL.X;
            vertex13.TextureCoordinate.Y = texCoordBR.Y;
            // TR { 1, 1 }
            vertex21.Position.X = x + w;
            vertex21.Position.Y = y;
            vertex21.Position.Z = depth;
            vertex21.Color = color;
            vertex21.TextureCoordinate.X = texCoordBR.X;
            vertex21.TextureCoordinate.Y = texCoordTL.Y;
            // BR { 1, 0 }
            vertex22.Position.X = x + w;
            vertex22.Position.Y = y + h;
            vertex22.Position.Z = depth;
            vertex22.Color = color;
            vertex22.TextureCoordinate.X = texCoordBR.X;
            vertex22.TextureCoordinate.Y = texCoordBR.Y;
            // BL { 0, 0 }
            vertex23.Position.X = x;
            vertex23.Position.Y = y + h;
            vertex23.Position.Z = depth;
            vertex23.Color = color;
            vertex23.TextureCoordinate.X = texCoordTL.X;
            vertex23.TextureCoordinate.Y = texCoordBR.Y;

        }
    }
}