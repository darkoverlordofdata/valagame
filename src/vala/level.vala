using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;

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
        public AssetHandle Mat;
    }

    [Compact, CCode (ref_function = "", unref_function = "")]
    public class Level 
    {
        public const int MAX_WIDTH = 512;
        public const int MAX_HEIGHT = 512;
        public int NumTileSets;
        public int* TileMap;
        public TileSet[] TileSets;
        public static int TileTypes;
        public static int[] TileCounts;

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

            TileTypes = TileType.All().length;
            TileCounts = new int[TileTypes]; 
            for (var i = 0; i < TileTypes; i++) 
            {
                TileCounts[i] = 0;
            }
            
            var level = new Level();
            level.NumTileSets = TileTypes;
            level.TileSets = new TileSet[TileTypes];
            level.TileMap = new int[MAX_WIDTH * MAX_HEIGHT];
            
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
                        level.TileMap[x + y * MAX_WIDTH] = type;
                        TileCounts[type]++;
                    }
                }
                
                y++;
            }

            /* Start from 1, type 0 is none! */
            for (var t = 1; t < TileTypes; t++) 
            {
                var numTiles = TileCounts[t];
                
                var positionData = new float[3 * 4 * numTiles];
                var uvData = new float[2 * 4 * numTiles];

                var i = 0;
                var j = 0;
                
                for (x = 0; x < MAX_WIDTH; x++) 
                {
                    for (y = 0; y < MAX_HEIGHT; y++) 
                    {
                        var type = level.TileMap[x + y * MAX_WIDTH];
                        if (type == t) {
                        
                            positionData[i++] = x * TILE_SIZE;
                            positionData[i++] = y * TILE_SIZE;
                            positionData[i++] = 0;
                            
                            positionData[i++] = (x+1) * TILE_SIZE;
                            positionData[i++] = y * TILE_SIZE;
                            positionData[i++] = 0;
                            
                            positionData[i++] = (x+1) * TILE_SIZE;
                            positionData[i++] = (y+1) * TILE_SIZE;
                            positionData[i++] = 0;
                            
                            positionData[i++] = x * TILE_SIZE;
                            positionData[i++] = (y+1) * TILE_SIZE;
                            positionData[i++] = 0;
                            
                            uvData[j++] = 0;
                            uvData[j++] = 0;
                            
                            uvData[j++] = 1;
                            uvData[j++] = 0;
                            
                            uvData[j++] = 1;
                            uvData[j++] = 1;
                            
                            uvData[j++] = 0;
                            uvData[j++] = 1;
                        }  
                    }
                }
                
                level.TileSets[t].NumTiles = numTiles;
                
                GL.GenBuffers(1, &level.TileSets[t].PositionsBuffer);
                GL.GenBuffers(1, &level.TileSets[t].TexcoordsBuffer);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, level.TileSets[t].PositionsBuffer);
                GL.BufferData(GL_ARRAY_BUFFER, sizeof(float) * 3 * 4 * numTiles, positionData, GL_STATIC_DRAW);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, level.TileSets[t].TexcoordsBuffer);
                GL.BufferData(GL_ARRAY_BUFFER, sizeof(float) * 2 * 4 * numTiles, uvData, GL_STATIC_DRAW);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, 0);
            
            }
            
            return (Component)level;
        }

        public void Dispose() 
        {
            /* Start from 1 as 0 is none tile set */
            for (var i = 1; i < NumTileSets; i++) 
            {
                GL.DeleteBuffers(1 , &TileSets[i].PositionsBuffer);
                GL.DeleteBuffers(1 , &TileSets[i].TexcoordsBuffer);
            }
            free();
        }
        
        public void RenderBackground(Vector2 camera) 
        {

            GL.Prolog();
            GL.BindTexture(GL_TEXTURE_2D, Texture.gl("Content/backgrounds/bluesky.dds"));
            GL.Begin(GL_QUADS);
            
            GL.Vertex3f(0, Corange.GraphicsHeight(), 0.0f);
            GL.TexCoord2f(1, 0);
            GL.Vertex3f(Corange.GraphicsWidth(), Corange.GraphicsHeight(), 0.0f);
            GL.TexCoord2f(1, 1);
            GL.Vertex3f(Corange.GraphicsWidth(), 0, 0.0f);
            GL.TexCoord2f(0, 1);
            GL.Vertex3f(0, 0, 0.0f);
            GL.TexCoord2f(0, 0);
            
            GL.End();
            GL.Epilog();
        }


        /* Renders each tileset in one go. Uses vertex buffers. */
        public void RenderTiles(Vector2 camera) 
        {

            GL.Prolog(camera);
            /* Start from 1, 0 is no tiles! */
            
            for (var i = 1; i < NumTileSets; i++) 
            {
                var tileTex = ((TileType)i).ToTexture();

                GL.BindTexture(GL_TEXTURE_2D, tileTex.handle());
                GL.TexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, (GLint)GL_CLAMP_TO_EDGE);
                GL.TexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, (GLint)GL_CLAMP_TO_EDGE);
                
                GL.EnableClientState(GL_VERTEX_ARRAY);
                GL.EnableClientState(GL_TEXTURE_COORD_ARRAY);
            
                GL.BindBuffer(GL_ARRAY_BUFFER, TileSets[i].PositionsBuffer);
                GL.VertexPointer(3, GL_FLOAT, 0, (GLvoid*)0);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, TileSets[i].TexcoordsBuffer);
                GL.TexCoordPointer(2, GL_FLOAT, 0, (GLvoid*)0);
                
                GL.DrawArrays(GL_QUADS, 0, TileSets[i].NumTiles * 4);
                
                GL.BindBuffer(GL_ARRAY_BUFFER, 0);
                GL.DisableClientState(GL_TEXTURE_COORD_ARRAY);  
                GL.DisableClientState(GL_VERTEX_ARRAY);
                
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
            return Vector2(x * TILE_SIZE, y * TILE_SIZE);
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

