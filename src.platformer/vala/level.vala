using System;
using ValaGame.OpenGL;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
/**
 * Level Component
 */
namespace Demo 
{
    public const int TileSize = 32;

    [SimpleType]
    public struct TileSet 
    {
        public int NumTiles;
        public uint PositionsBuffer;
        public uint TexcoordsBuffer;
    }

    public class Level : Object, IDisposable
    {
        public const int MaxWidth = 512;
        public const int MaxHeight = 512;
        public TileSet[] TileSets;
        public Vector2 Position;
        public Vector2 Size;
        public Texture2D[] Sprite;
        public ITileMap Tiles;

        /** 
         * Register the level Asset - "levels/*.level"
         */
        public static void Register() { Asset.Handler(Type, "level", Create, Dispose); }
        public static int Type { get { return Entity.Register("Level", sizeof(Level)); } }

        /** 
         * Level Factory 
         */
        private static Object Create(string filename) 
        {
            return new Level(filename);
        }

        private Level(string filename)
        {
            Tiles = new TileMap(filename, MaxWidth, MaxHeight);
            TileSets = new TileSet[Tiles.Count];
            CreateSpriteBatch(TileSize, TileSize);
            Position = Vector2.Zero;
            var rectangle = Game.Instance.Window.ClientBounds;
            Size = Vector2(rectangle.Width, rectangle.Height);
            Sprite = new Texture2D[Tiles.Count];

            foreach (int tile in Tiles.Path.Keys)
                Sprite[tile] = Game.Instance.Content.Load<Texture2D>((Tiles.ToString(tile)));
        }

        public void Dispose() 
        {
            foreach (var tile in Tiles.Path.Keys)
            {
                if (tile != 0)
                {
                    GL.DeleteBuffers(1 , &TileSets[tile].PositionsBuffer);
                    GL.DeleteBuffers(1 , &TileSets[tile].TexcoordsBuffer);
                }
            }
        }
        
        public void Render(Vector2 camera) 
        {
            // Draw Background Sprite
            GL.Use2DCamera();
            GL.BindTexture(TextureTarget.Texture2D, Sprite[0].Handle);
            GL.Draw(Position, Size);

            // Draw Sprite batch
            GL.Use2DCamera(camera);
            foreach (var tile in Tiles.Path.Keys)
            {
                if (tile == 0) continue;
                GL.BindTexture(TextureTarget.Texture2D, Sprite[tile].Handle);
                GL.DrawUserArrays(
                    TileSets[tile].NumTiles, 
                    TileSets[tile].PositionsBuffer, 
                    TileSets[tile].TexcoordsBuffer);
            }
        }

        public int TileAt(Vector2 positions) 
        {
            var x = (int)Math.floor( positions.X / TileSize );
            var y = (int)Math.floor( positions.Y / TileSize );
            
            assert(x >= 0);
            assert(y >= 0);
            assert(x < MaxWidth);
            assert(y < MaxHeight);
            
            return Tiles.At(x, y);
            
        }

        public Vector2 TilePosition(int x, int y) 
        {
            return new Vector2(x * TileSize, y * TileSize);
        }

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

        public void CreateSpriteBatch(int width, int height) 
        {
            // projection matrix for GL_TRIANGLES 
            short[,,] Z = {
                {   // Normal
                    // TR        TL        BL        TR        BR        BL
                    { 0, 1 }, { 0, 0 }, { 1, 0 }, { 0, 1 }, { 1, 1 }, { 1, 0 }
                },
                {   // Inverted
                    // BR        BL        TL        BR        TR        TL
                    { 1, 1 }, { 1, 0 }, { 0, 0 }, { 1, 1 }, { 0, 1 }, { 0, 0 }
                }
            };            

            for (var tile = 0; tile < Tiles.Count; tile++)
            {
                if (tile == 0) continue;

                var count = Tiles.CountOf(tile);
                var positions = new Vertex3fArray(count);
                var texcoords = new TexCoords3fArray(count);

                for (var x = 0; x < MaxWidth; x++) 
                {
                    for (var y = 0; y < MaxHeight; y++) 
                    {
                        if (tile == Tiles.At(x, y))
                        {   
                            for (var i=0; i<6; i++) // Generate 6 pts. for 2 triangles
                            {
                                positions.Add((x+Z[0,i,0]) * width, (y+Z[0,i,1]) * height, 0);
                                texcoords.Add(Z[0,i,0], Z[0,i,1]); 
                            }
                        }
                    }
                }
                
                TileSets[tile].NumTiles = count;
                
                GL.GenBuffers(1, &TileSets[tile].PositionsBuffer);
                GL.GenBuffers(1, &TileSets[tile].TexcoordsBuffer);
                
                GL.BindBuffer(BufferTarget.ArrayBuffer, TileSets[tile].PositionsBuffer);
                GL.BufferData(BufferTarget.ArrayBuffer, positions.size, positions.data, BufferUsageHint.StaticDraw);
                
                GL.BindBuffer(BufferTarget.ArrayBuffer, TileSets[tile].TexcoordsBuffer);
                GL.BufferData(BufferTarget.ArrayBuffer, texcoords.size, texcoords.data, BufferUsageHint.StaticDraw);
                
                GL.BindBuffer(BufferTarget.ArrayBuffer, 0);
            }
        }

    }    
}


