using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Data;
using Microsoft.Xna.Framework.Assets;
using Microsoft.Xna.Framework.Content;

namespace Demo {

    public Texture tmp;

    public enum TileType {
        NONE, AIR, DIRT, DIRT_ROCK, DIRT_OVERHANG,
        SURFACE, GRASS, GRASS_ROCK1, GRASS_ROCK2, GRASS_TREE,
        TREE, TREE_TOP, TREE_TOP_LEFT, TREE_TOP_RIGHT, TREE_TOPEST,
        TREE_BOT_LEFT, TREE_BOT_RIGHT, TREE_JUNC_LEFT, TREE_JUNC_RIGHT,
        TREE_TURN_LEFT, TREE_TURN_RIGHT, TREE_SIDE, HOUSE_TOP_LEFT, 
        HOUSE_TOP_RIGHT, HOUSE_BOT_LEFT, HOUSE_BOT_RIGHT;

        public static TileType[] All() {
            return { 
                NONE, AIR, DIRT, DIRT_ROCK, DIRT_OVERHANG,
                SURFACE, GRASS, GRASS_ROCK1, GRASS_ROCK2, GRASS_TREE,
                TREE, TREE_TOP, TREE_TOP_LEFT, TREE_TOP_RIGHT, TREE_TOPEST,
                TREE_BOT_LEFT, TREE_BOT_RIGHT, TREE_JUNC_LEFT, TREE_JUNC_RIGHT,
                TREE_TURN_LEFT, TREE_TURN_RIGHT, TREE_SIDE, HOUSE_TOP_LEFT, 
                HOUSE_TOP_RIGHT, HOUSE_BOT_LEFT, HOUSE_BOT_RIGHT 
            };
            
        }

        public static bool HasCollision(int tiletype) {
            switch(tiletype) {
                case DIRT: return true;
                case DIRT_ROCK: return true;
                case DIRT_OVERHANG: return true;
                case SURFACE: return true;
                case GRASS_ROCK1: return true;
                case HOUSE_BOT_LEFT: return true;
                case HOUSE_BOT_RIGHT: return true;
                case HOUSE_TOP_LEFT: return true;
                case HOUSE_TOP_RIGHT: return true;
                default: return false;
            }
        }

        /* Levels are basically stored in an ascii file, with these being the tile type characters. */
        public static TileType FromChar(char c) {
    
            switch(c) {
                case '\r': return NONE; 
                case '\n': return NONE; 
                case ' ': return NONE;
                case '`': return AIR;
                case '#': return DIRT;
                case 'R': return DIRT_ROCK;
                case '"': return DIRT_OVERHANG;
                case '~': return SURFACE;
                case '_': return GRASS;
                case '@': return GRASS_ROCK1;
                case '.': return GRASS_ROCK2;
                case '!': return GRASS_TREE;
                case '|': return TREE;
                case '\'': return TREE_TOP;
                case '{': return TREE_TOP_LEFT;
                case '}': return TREE_TOP_RIGHT;
                case '^': return TREE_TOPEST;
                case '(': return TREE_BOT_LEFT;
                case ')': return TREE_BOT_RIGHT;
                case '+': return TREE_JUNC_RIGHT;
                case '*': return TREE_JUNC_LEFT;
                case '/': return TREE_TURN_RIGHT;
                case '\\': return TREE_TURN_LEFT;
                case '-': return TREE_SIDE;
                case 'h': return HOUSE_BOT_LEFT;
                case 'u': return HOUSE_BOT_RIGHT;
                case 'd': return HOUSE_TOP_LEFT;
                case 'b': return HOUSE_TOP_RIGHT;
                default: 
                    stdout.printf("Unknown tile type character: '%c', %d\n", c, (int)c);
                    return NONE;
            }
        }
        /* These vast case statements are basically a nasty way of assigning properties to the tile types */
        public string ToString() {
            switch(this) {
                case NONE: return "Content/tiles/tile_sky.dds";
                case AIR: return "Content/tiles/tile_sky.dds";
                case DIRT: return "Content/tiles/tile_dirt.dds";
                case DIRT_ROCK: return "Content/tiles/tile_dirt_rock.dds";
                case DIRT_OVERHANG: return "Content/tiles/tile_dirt_overhang.dds";
                case SURFACE: return "Content/tiles/tile_surface.dds";
                case GRASS: return "Content/tiles/tile_grass.dds";
                case GRASS_ROCK1: return "Content/tiles/tile_grass_rock1.dds";
                case GRASS_ROCK2: return "Content/tiles/tile_grass_rock2.dds";
                case GRASS_TREE: return "Content/tiles/tile_grass_tree.dds";
                case TREE: return "Content/tiles/tile_tree.dds";
                case TREE_TOP: return "Content/tiles/tile_tree_top.dds";
                case TREE_TOP_LEFT: return "Content/tiles/tile_tree_top_left.dds";
                case TREE_TOP_RIGHT: return "Content/tiles/tile_tree_top_right.dds";
                case TREE_TOPEST: return "Content/tiles/tile_tree_topest.dds";
                case TREE_BOT_LEFT: return "Content/tiles/tile_tree_bot_left.dds";
                case TREE_BOT_RIGHT: return "Content/tiles/tile_tree_bot_right.dds";
                case TREE_JUNC_LEFT: return "Content/tiles/tile_tree_junc_left.dds";
                case TREE_JUNC_RIGHT: return "Content/tiles/tile_tree_junc_right.dds";
                case TREE_TURN_LEFT: return "Content/tiles/tile_tree_turn_left.dds";
                case TREE_TURN_RIGHT: return "Content/tiles/tile_tree_turn_right.dds";
                case TREE_SIDE: return "Content/tiles/tile_tree_side.dds";
                case HOUSE_BOT_LEFT: return "Content/tiles/tile_house_bot_left.dds";
                case HOUSE_BOT_RIGHT: return "Content/tiles/tile_house_bot_right.dds";
                case HOUSE_TOP_LEFT: return "Content/tiles/tile_house_top_left.dds";
                case HOUSE_TOP_RIGHT: return "Content/tiles/tile_house_top_right.dds";
                default: assert_not_reached();
            }
        }  

    }
}