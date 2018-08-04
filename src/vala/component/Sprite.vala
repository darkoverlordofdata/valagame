namespace Demo 
{
    using Artemis;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    /**
     * @name - the name of the texture region in the atlas
     * @depth - z-axis for 2D layout
     * @region - a texture region in an atlas
     *
     */
    public class Sprite : Component
    {
        public string name;
        public Vector2 scale;
        public float r = 1;
        public float g = 1;
        public float b = 1;
        public float a = 1;
        public float depth;
        public TextureRegion region;
    }
}
