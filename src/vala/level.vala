using GL;
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
        public int NumTileSets;
        public int* TileMap;
        public TileSet[] TileSets;
        public int[] TileCounts;
        public Vector2 Position;
        public Vector2 Size;
        public GL.GLuint[] Sprite;
        // Identity matrix for GL_TRIANGLES 
        public int[,,] Z = {
            {   // Normal
                { 0, 1 }, { 0, 0 }, { 1, 0 },
                { 0, 1 }, { 1, 1 }, { 1, 0 }
            },
            {   // Inverted
                { 1, 1 }, { 1, 0 }, { 0, 0 },
                { 1, 1 }, { 0, 1 }, { 0, 0 }
            }
        };

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
            TileCounts = new int[TileType.All().length]; 
            for (var i = 0; i < TileCounts.length; i++) 
                TileCounts[i] = 0;
            
            NumTileSets = TileCounts.length;
            TileSets = new TileSet[NumTileSets];
            TileMap = new int[MAX_WIDTH * MAX_HEIGHT];
            LoadMap(filename);
            CreateTileBatch();
            Position = Vector2.Zero;
            Size = Vector2(corange_graphics_viewport_width(), corange_graphics_viewport_height());
            Sprite = new GL.GLuint[TileType.All().length];
            foreach (var tile in TileType.All())
                Sprite[tile] = Game.Instance.Content.LoadTexture(tile.ToString());
        }

        public void Dispose() 
        {
            foreach (var tile in TileType.All())
            {
                if (tile != TileType.BGD)
                {
                    GL.DeleteBuffers(1 , &TileSets[tile].PositionsBuffer);
                    GL.DeleteBuffers(1 , &TileSets[tile].TexcoordsBuffer);
                }
            }
            free();
        }
        
        public void Render(Vector2 camera) 
        {
            // Draw One Sprite
            GL.PushState();
            GL.BindTexture(GL_TEXTURE_2D, Sprite[TileType.BGD]);
            GL.Draw(Position, Size);
            GL.PopState();

            // Draw Sprite batch
            GL.PushState(camera);
            foreach (var tile in TileType.All())
            {
                if (tile == TileType.BGD) continue;
                GL.BindTexture(GL_TEXTURE_2D, Sprite[tile]);
                GL.DrawBuffers(
                    TileSets[tile].NumTiles, 
                    TileSets[tile].PositionsBuffer, 
                    TileSets[tile].TexcoordsBuffer);
            }
            GL.PopState();
        }

        public int TileAt(Vector2 position) 
        {
            var x = (int)Math.floor( position.X / TILE_SIZE );
            var y = (int)Math.floor( position.Y / TILE_SIZE );
            
            assert(x >= 0);
            assert(y >= 0);
            assert(x < MAX_WIDTH);
            assert(y < MAX_HEIGHT);
            
            return TileMap[x + y * MAX_WIDTH];
            
        }

        public Vector2 TilePosition(int x, int y) 
        {
            return new Vector2(x * TILE_SIZE, y * TILE_SIZE);
        }

        public void CreateTileBatch() 
        {

            foreach (var t in TileType.All())
            {
                if (t == TileType.BGD) continue;
            
                /**
                * for each tile type, get all the locations it 
                * appears, and add them to the vertex array.
                */
                var count = TileCounts[t];
                var verts = new Vertex3fArray(count);
                var coord = new TexCoords3fArray(count);

                for (var x = 0; x < MAX_WIDTH; x++) 
                {
                    for (var y = 0; y < MAX_HEIGHT; y++) 
                    {
                        if (t == TileMap[x + y * MAX_WIDTH])
                        {
                            for (var i=0; i<6; i++)
                            {
                                coord.Add(Z[0,i,0], Z[0,i,1]); 
                                verts.Add((x+Z[0,i,0]) * TILE_SIZE, (y+Z[0,i,1]) * TILE_SIZE, 0);
                            }
                        }
                    }
                }
                
                TileSets[t].NumTiles = count;
                
                GL.GenBuffers(1, &TileSets[t].PositionsBuffer);
                GL.GenBuffers(1, &TileSets[t].TexcoordsBuffer);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, TileSets[t].PositionsBuffer);
                GL.BufferData(GL_ARRAY_BUFFER, verts.size, verts.data, GL_STATIC_DRAW);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, TileSets[t].TexcoordsBuffer);
                GL.BufferData(GL_ARRAY_BUFFER, coord.size, coord.data, GL_STATIC_DRAW);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, 0);
            }
        }

        public void LoadMap(string filename)
        {
            var y = 0;
            var x = 0;
            var line = new char[MAX_WIDTH];
            var file = Sdl.RWFromFile(filename, "r");
            while (ReadLine(file, line, 1024) != 0) 
            {
                for (x = 0; x < line.length; x++) 
                {
                    var c = line[x];
                    if (c != 0) 
                    {
                        var type = TileType.FromChar(c);
                        TileMap[x + y * MAX_WIDTH] = type;
                        TileCounts[type]++;
                    }
                }
                y++;
            }
        }
    }    
}

public int ReadLine(Sdl.RWops* rw, char* buffer, int buffersize) 
{
    char c = '\0';
    size_t status = 0;
    int i = 0;
    while(true) 
    {
      status = Sdl.RWread(rw, &c, 1, 1);
      
      if (status == -1) return -1;
      if (i == buffersize-1) return -1;
      if (status == 0) break;
      
      buffer[i] = c;
      i++;
      
      if (c == '\n') {
        buffer[i] = '\0';
        return i;
      }
    }
    
    if(i > 0) {
      buffer[i] = '\0';
      return i;
    } else {
      return 0;
    }              
}

