namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class Bounds : Component
    {
        public float X;
        public float Y;

        /// <summary>Initializes a new instance of the <see cref="BoundsComponent" /> class.</summary>
        public Bounds.Empty()
        {
            X = 0f;
            Y = 0f;
        }

        /// <summary>Initializes a new instance of the <see cref="BoundsComponent"/> class.</summary>
        /// <param name="x">The x.</param>
        /// <param name="y">The y.</param>
        public Bounds(Sprite s)
        {
            X = s.X * s.Region.Width;
            Y = s.Y * s.Region.Height;
        }
    }
}