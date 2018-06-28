using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace Demo {

    public class TileMap : Object, ITileMap
    {
        HashMap<int, string> _path;
        HashMap<char, int> _char;
        HashSet<int> _collision;
        string _datafile;
        int[] _tileMap;
        int[] _tileCounts;
        int _width;
        int _height;

        public HashMap<int, string> Path { get { return _path; } }
        public int Count { get { return _tileCounts.length; } }
 
        public TileMap(string filename, int width, int height)
        {
            _datafile = URI(filename).Location().to_string() + "demo.data";
            _path = new HashMap<int, string>();
            _collision = new HashSet<int>();
            _char = new HashMap<char, int>();
            
            var tiles = "`%R\"~_@.!|'{}^()+*/\\-hudb";
            for (int i=0; i<tiles.length; i++)
            {
                _char.set(tiles[i], i+1);
            }

            _path.set( 0, "backgrounds/bluesky.dds");
            _path.set( 1, "tiles/tile_sky.dds");
            _path.set( 2, "tiles/tile_dirt.dds");
            _path.set( 3, "tiles/tile_dirt_rock.dds");
            _path.set( 4, "tiles/tile_dirt_overhang.dds");
            _path.set( 5, "tiles/tile_surface.dds");
            _path.set( 6, "tiles/tile_grass.dds");
            _path.set( 7, "tiles/tile_grass_rock1.dds");
            _path.set( 8, "tiles/tile_grass_rock2.dds");
            _path.set( 9, "tiles/tile_grass_tree.dds");
            _path.set(10, "tiles/tile_tree.dds");
            _path.set(11, "tiles/tile_tree_top.dds");
            _path.set(12, "tiles/tile_tree_top_left.dds");
            _path.set(13, "tiles/tile_tree_top_right.dds");
            _path.set(14, "tiles/tile_tree_topest.dds");
            _path.set(15, "tiles/tile_tree_bot_left.dds");
            _path.set(16, "tiles/tile_tree_bot_right.dds");
            _path.set(17, "tiles/tile_tree_junc_right.dds");
            _path.set(18, "tiles/tile_tree_junc_left.dds");
            _path.set(19, "tiles/tile_tree_turn_right.dds");
            _path.set(20, "tiles/tile_tree_turn_left.dds");
            _path.set(21, "tiles/tile_tree_side.dds");
            _path.set(22, "tiles/tile_house_bot_left.dds");
            _path.set(23, "tiles/tile_house_bot_right.dds");
            _path.set(24, "tiles/tile_house_top_left.dds");
            _path.set(25, "tiles/tile_house_top_right.dds");

            var hits = "%R\"~@hudb";
            for (int i=0; i<hits.length; i++)
            {
                _collision.add(tiles.index_of(hits[i].to_string())+1);
            }

            _tileCounts = new int[_path.size]; 
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
            if (_path.contains(tile))
                return _path[tile];
            return "";
        }

        public int FromChar(char tile)
        {
            if (_char.contains(tile))
                return _char[tile];
            return -1;
        }
        
        public bool HasCollision(int tile)
        {
            return _collision.contains(tile);
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
                        if (_char.contains(c))
                        {
                            // var type = TileMap.FromChar(c);
                            var type = _char[c];
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