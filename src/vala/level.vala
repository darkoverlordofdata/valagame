using GL1;
using Gee;
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
        public GLuint PositionsBuffer;
        public GLuint TexcoordsBuffer;
    }

    [Compact, CCode (ref_function = "", unref_function = "")]
    public class Level 
    {
        public const int MAX_WIDTH = 512;
        public const int MAX_HEIGHT = 512;
        public TileSet[] TileSets;
        public Vector2 Position;
        public Vector2 Size;
        public Texture2D[] Sprite;
        public ITileMap Tiles;

        public extern void free();

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

            foreach (int tile in Tiles.Path.keys)
                Sprite[tile] = Game.Instance.Content.Load<Texture2D>((Tiles.ToString(tile)));
        }

        public void Dispose() 
        {
            foreach (var tile in Tiles.Path.keys)
            {
                if (tile != 0)
                {
                    GL1.DeleteBuffers(1 , &TileSets[tile].PositionsBuffer);
                    GL1.DeleteBuffers(1 , &TileSets[tile].TexcoordsBuffer);
                }
            }
            free();
        }
        
        public void Render(Vector2 camera) 
        {
            // Draw One Sprite
            GL1.PushState();
            GL1.BindTexture(TextureTarget.Texture2D, Sprite[0].Handle);
            GL1.Draw(Position, Size);
            GL1.PopState();

            // Draw Sprite batch
            GL1.PushState(camera);
            foreach (var tile in Tiles.Path.keys)
            {
                if (tile == 0) continue;
                GL1.BindTexture(TextureTarget.Texture2D, Sprite[tile].Handle);
                GL1.DrawUserArrays(
                    TileSets[tile].NumTiles, 
                    TileSets[tile].PositionsBuffer, 
                    TileSets[tile].TexcoordsBuffer);
            }
            GL1.PopState();
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
                
                GL1.GenBuffers(1, &TileSets[tile].PositionsBuffer);
                GL1.GenBuffers(1, &TileSets[tile].TexcoordsBuffer);
                
                GL1.BindBuffer(BufferTarget.ArrayBuffer, TileSets[tile].PositionsBuffer);
                GL1.BufferData(BufferTarget.ArrayBuffer, positions.size, positions.data, GL_STATIC_DRAW);
                
                GL1.BindBuffer(BufferTarget.ArrayBuffer, TileSets[tile].TexcoordsBuffer);
                GL1.BufferData(BufferTarget.ArrayBuffer, texcoords.size, texcoords.data, GL_STATIC_DRAW);
                
                GL1.BindBuffer(BufferTarget.ArrayBuffer, 0);
            }
        }

    }    
}


