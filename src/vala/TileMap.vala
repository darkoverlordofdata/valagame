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
            KeyFile ini = new KeyFile();
            ini.load_from_file(filename, KeyFileFlags.NONE);

            _datafile = URI(filename).Location().to_string() + ini.get_string("tilemap", "data");
            _path = new HashMap<int, string>();
            _collision = new HashSet<int>();
            _char = new HashMap<char, int>();
            
            _path.set(0, ini.get_string("tilemap", "background"));
            var tiles = ini.get_string("tilemap", "tiles");
            for (int i=0; i<tiles.length; i++)
            {
                var value = ini.get_string("tiles", tiles[i].to_string());
                _path.set(i+1, value);
                _char.set(tiles[i], i+1);
            }

            var hits = ini.get_string("tilemap", "hits");
            for (int i=0; i<hits.length; i++)
            {
                _collision.add(tiles.index_of_char(hits[i])+1);
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