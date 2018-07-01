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
    public const int TILE_SIZE = 32;

    [SimpleType]
    public struct TileSet 
    {
        public int NumTiles;
        public uint PositionsBuffer;
        public uint TexcoordsBuffer;
    }

    public class Level : Object, IDisposable
    {
        public const int MAX_WIDTH = 512;
        public const int MAX_HEIGHT = 512;
        public TileSet[] TileSets;
        public Vector2 Position;
        public Vector2 Size;
        public Texture2D[] Sprite;
        public ITileMap Tiles;

        /** 
         * Register the Level class type 
         */
        public static int Type { get { return Entity.Register("Level", sizeof(Level)); } }
        /** 
         * Register handlers for creating and destroying Level type
         * Registering as an asset calls create when the asset *.level is loaded 
         */
        public static void Register() { Asset.Handler(Type, "level", Create, Dispose); }
        /** 
         * Level factory method 
         */
        public static Entity Create(string filename) 
        {
            return (Entity) new Level(filename);
        }

        public Level(string filename)
        {
            Tiles = new TileMap(filename, MAX_WIDTH, MAX_HEIGHT);
            TileSets = new TileSet[Tiles.Count];
            CreateSpriteBatch(TILE_SIZE, TILE_SIZE);
            Position = Vector2.Zero;
            var rectangle = Game.Instance.Window.ClientBounds;
            Size = Vector2(rectangle.Width, rectangle.Height);
            Sprite = new Texture2D[Tiles.Count];

            foreach (int tile in Tiles.Path.get_keys())
                Sprite[tile] = Game.Instance.Content.Load<Texture2D>((Tiles.ToString(tile)));
        }

        public void Dispose() 
        {
            foreach (var tile in Tiles.Path.get_keys())
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
            foreach (var tile in Tiles.Path.get_keys())
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
            var x = (int)Math.floor( positions.X / TILE_SIZE );
            var y = (int)Math.floor( positions.Y / TILE_SIZE );
            
            assert(x >= 0);
            assert(y >= 0);
            assert(x < MAX_WIDTH);
            assert(y < MAX_HEIGHT);
            
            return Tiles.At(x, y);
            
        }

        public Vector2 TilePosition(int x, int y) 
        {
            return new Vector2(x * TILE_SIZE, y * TILE_SIZE);
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

                for (var x = 0; x < MAX_WIDTH; x++) 
                {
                    for (var y = 0; y < MAX_HEIGHT; y++) 
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


