namespace Demo 
{
    using Artemis;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;
    using Microsoft.Xna.Framework.Content;

    /**
     * @name - the name of the texture region in the atlas
     * @depth - z-axis for 2D layout
     * @region - a texture region in an atlas
     *
     */
    public class Sprite : Component
    {
        // static TextureAtlas atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");

        public string Name;
        public float X;
        public float Y;
        public float R;
        public float G;
        public float B;
        public float A;
        public float Depth;
        public bool Centered;

        /// <summary>Initializes a new instance of the <see cref="BoundsComponent" /> class.</summary>
        public Sprite.Empty()
        {
            this(null, 1f, 1f, 1f, 1f, 1f, 1f, 1f);
        }

        /// <summary>Initializes a new instance of the <see cref="SpriteComponent"/> class.</summary>
        /// <param name="name">The texture name.</param>
        /// <param name="x">The apparent depth for display.</param>
        /// <param name="x">The x position.</param>
        /// <param name="y">The y position.</param>
        /// <param name="r">The red value.</param>
        /// <param name="r">The green value.</param>
        /// <param name="r">The blue value.</param>
        /// <param name="r">The alpha value.</param>
        public Sprite(
            string? name = null, 
            float depth=1f, 
            float x=1f, 
            float y=1f, 
            float r=1f,
            float g=1f,
            float b=1f,
            float a=1f)
        {
            Name = name;
            Depth = depth;
            X = x;
            Y = y;
            R = r;
            G = g;
            B = b;
            A = a;
            if (name != null) Load();
            Centered = true;
        }

        /// <summary>Gets the sprite texture data.</summary>
        /// <value>The sprite texture data.</value>
        public Texture2D Region { get; private set; }

        public void Load()
        {
            Region = ResourceManager.GetTexture(Name);
        }
    }
}
