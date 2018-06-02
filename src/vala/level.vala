using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;
using Microsoft.Xna.Framework.Content;

/**
 * Level Component
 */
namespace Demo 
{

    public class Vertex3fArray : Object
    {
        public float[] data;
        public int count;
        public int size;

        public Vertex3fArray(int size)
        {
            this.size = (int)sizeof(float) * 3 * 6 * size;
            count = 0;
            data = new float[3 * 6 * size];
        }

        public void Add(float x, float y, float z)
        {
            data[count++] = x;
            data[count++] = y;
            data[count++] = z;
        }

    }

    public class TexCoords3fArray : Object
    {
        public float[] data;
        public int count;
        public int size;

        public TexCoords3fArray(int size)
        {
            this.size = (int)sizeof(float) * 2 * 6 * size;
            count = 0;
            data = new float[2 * 6 * size];
        }

        public void Add(float x, float y)
        {
            data[count++] = x;
            data[count++] = y;
        }

    }    
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
        public GL.GLuint Sprite;

        public extern void free();

        /** Register the Level class type */
        public static int Type { get { return Component.Register("Level", sizeof(Level)); } }
        /** Register functions for loading/unloading files with the extension .level */
        public static void Register() { Asset.Handler(Type, "level", Create, Dispose); }

        /** 
         * Level factory method 
         */
        public static Component Create(string filename) 
        {
            return (Component) new Level(filename);
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
            CreateBatch();
            Position = Vector2.Zero;
            Size = Vector2(Corange.Width, Corange.Height);
            Sprite = Texture.GL("Content/backgrounds/bluesky.dds");
        }

        public void Dispose() 
        {
            foreach (var tile in TileType.All())
            {
                if (tile != TileType.NONE)
                {
                    GL.DeleteBuffers(1 , &TileSets[tile].PositionsBuffer);
                    GL.DeleteBuffers(1 , &TileSets[tile].TexcoordsBuffer);
                }
            }
            free();
        }
        
        public void RenderBackground(Vector2 camera) 
        {
            GL.Prolog();
            GL.BindTexture(GL_TEXTURE_2D, Sprite);
            GL.Draw(Position, Size);
            GL.Epilog();
        }


        public void RenderTiles(Vector2 camera) 
        {
            GL.Prolog(camera);
            foreach (var tile in TileType.All())
            {
                if (tile == TileType.NONE) continue;
		        GL.BindTexture(GL_TEXTURE_2D, Texture.GL(tile.ToString()));
                GL.DrawBuffers(
                    TileSets[tile].NumTiles, 
                    TileSets[tile].PositionsBuffer, 
                    TileSets[tile].TexcoordsBuffer);
            }
            GL.Epilog();
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

        public void CreateBatch() 
        {
            foreach (var t in TileType.All())
            {
                if (t == TileType.NONE) continue;
            
                var numTiles = TileCounts[t];
                var verts = new Vertex3fArray(numTiles);
                var coords = new TexCoords3fArray(numTiles);
                
                for (var x = 0; x < MAX_WIDTH; x++) 
                {
                    for (var y = 0; y < MAX_HEIGHT; y++) 
                    {
                        var type = TileMap[x + y * MAX_WIDTH];
                        if (type == t) 
                        {
                            coords.Add(0, 1); verts.Add(x * TILE_SIZE, (y+1) * TILE_SIZE, 0);
                            coords.Add(0, 0); verts.Add(x * TILE_SIZE, y * TILE_SIZE, 0);
                            coords.Add(1, 0); verts.Add((x+1) * TILE_SIZE, y * TILE_SIZE, 0);

                            coords.Add(0, 1); verts.Add(x * TILE_SIZE, (y+1) * TILE_SIZE, 0);
                            coords.Add(1, 1); verts.Add((x+1) * TILE_SIZE, (y+1) * TILE_SIZE, 0);
                            coords.Add(1, 0); verts.Add((x+1) * TILE_SIZE, y * TILE_SIZE, 0);
                        }  
                    }
                }
                
                TileSets[t].NumTiles = numTiles;
                
                GL.GenBuffers(1, &TileSets[t].PositionsBuffer);
                GL.GenBuffers(1, &TileSets[t].TexcoordsBuffer);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, TileSets[t].PositionsBuffer);
                GL.BufferData(GL_ARRAY_BUFFER, verts.size, verts.data, GL_STATIC_DRAW);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, TileSets[t].TexcoordsBuffer);
                GL.BufferData(GL_ARRAY_BUFFER, coords.size, coords.data, GL_STATIC_DRAW);
                
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

