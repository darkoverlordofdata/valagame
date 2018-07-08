using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace Demo {

    public class TileMap : Object, ITileMap
    {
        Dictionary<int, string> _path;
        Dictionary<char, int> _tile;
        Dictionary<int, char> _hits;
        HashSet<int> _collision;
        string _datafile;
        int[] _tileMap;
        int[] _tileCounts;
        int _width;
        int _height;

        public Dictionary<int, string> Path { get { return _path; } }
        public int Count { get { return _tileCounts.length; } }
 
        public TileMap(string filename, int width, int height)
        {
            _datafile = filename;
            _path = new Dictionary<int, string>();
            _collision = new HashSet<int>();
            _tile = new Dictionary<char, int>();
            _hits = new Dictionary<int, char>();
            
            _tile['`'] = 1;
            _tile['%'] = 2;
            _tile['R'] = 3;
            _tile['"'] = 4;
            _tile['~'] = 5;
            _tile['_'] = 6;
            _tile['@'] = 7;
            _tile['.'] = 8;
            _tile['!'] = 9;
            _tile['|'] = 10;
            _tile['\''] = 11;
            _tile['{'] = 12;
            _tile['}'] = 13;
            _tile['^'] = 14;
            _tile['('] = 15;
            _tile[')'] = 16;
            _tile['+'] = 17;
            _tile['*'] = 18;
            _tile['/'] = 19;
            _tile['\\'] = 20;
            _tile['-'] = 21;
            _tile['h'] = 22;
            _tile['u'] = 23;
            _tile['d'] = 24;
            _tile['b'] = 25;

            _hits[0] = '%';
            _hits[1] = 'R';
            _hits[2] = '"';
            _hits[3] = '~';
            _hits[4] = '@';
            _hits[5] = 'h';
            _hits[6] = 'u';
            _hits[7] = 'd';
            _hits[8] = 'b';

            _path[0] = "backgrounds/bluesky.dds";
            _path[1] = "tiles/tile_sky.dds";
            _path[2] = "tiles/tile_dirt.dds";
            _path[3] = "tiles/tile_dirt_rock.dds";
            _path[4] = "tiles/tile_dirt_overhang.dds";
            _path[5] = "tiles/tile_surface.dds";
            _path[6] = "tiles/tile_grass.dds";
            _path[7] = "tiles/tile_grass_rock1.dds";
            _path[8] = "tiles/tile_grass_rock2.dds";
            _path[9] = "tiles/tile_grass_tree.dds";
            _path[10] = "tiles/tile_tree.dds";
            _path[11] = "tiles/tile_tree_top.dds";
            _path[12] = "tiles/tile_tree_top_left.dds";
            _path[13] = "tiles/tile_tree_top_right.dds";
            _path[14] = "tiles/tile_tree_topest.dds";
            _path[15] = "tiles/tile_tree_bot_left.dds";
            _path[16] = "tiles/tile_tree_bot_right.dds";
            _path[17] = "tiles/tile_tree_junc_right.dds";
            _path[18] = "tiles/tile_tree_junc_left.dds";
            _path[19] = "tiles/tile_tree_turn_right.dds";
            _path[20] = "tiles/tile_tree_turn_left.dds";
            _path[21] = "tiles/tile_tree_side.dds";
            _path[22] = "tiles/tile_house_bot_left.dds";
            _path[23] = "tiles/tile_house_bot_right.dds";
            _path[24] = "tiles/tile_house_top_left.dds";
            _path[25] = "tiles/tile_house_top_right.dds";

            for (int i=0; i<_hits.Count; i++)
                _collision.Add(_tile[_hits[i]]);

            _tileCounts = new int[_path.Count]; 
            for (var i = 0; i < _tileCounts.length; i++) 
                _tileCounts[i] = 0;

            _tileMap = new int[width * height];
            _width = width;
            _height = height;
            LoadMap();
        }

        public int At(int x, int y)
        {
            return _tileMap[x + y * _width];
        }

        public int CountOf(int tile)
        {
            return _tileCounts[tile];
        }


        public string ToString(int tile)
        {
            if (_path.Contains(tile))
                return _path[tile];
            return "";
        }

        public int FromChar(char tile)
        {
            if (_tile.Contains(tile))
                return _tile[tile];
            return -1;
        }
        
        public bool HasCollision(int tile)
        {
            return _collision.Contains(tile);
        }
        
        void LoadMap() //int[] tileMap, int[] tileCounts)
        {
            var y = 0;
            var x = 0;
            var line = new char[_width];
            var file = Sdl.RWFromFile(_datafile, "r");
            while (ReadLine(file, line, 1024) != 0) 
            {
                for (x = 0; x < line.length; x++) 
                {
                    var c = line[x];
                    if (c != 0) 
                    {
                        if (_tile.Contains(c))
                        {
                            // var type = TileMap.FromChar(c);
                            var type = _tile[c];
                            _tileMap[x + y * _height] = type;
                            _tileCounts[type]++;
                        }
                    }
                }
                y++;
            }
        }
        
        int ReadLine(Sdl.RWops* rw, char* buffer, int buffersize) 
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
    }
}