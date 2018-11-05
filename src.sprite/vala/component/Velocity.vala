namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class Velocity : Component
    {
        public float X;
        public float Y;

        /// <summary>Initializes a new instance of the <see cref="VelocityComponent" /> class.</summary>
        public Velocity.Empty()
        {
            this(0f, 0f);
        }

        /// <summary>Initializes a new instance of the <see cref="BoundsComponent"/> class.</summary>
        /// <param name="x">The x.</param>
        /// <param name="y">The y.</param>
        public Velocity(float x, float y)
        {
            X = x;
            Y = y;
        }

    }
}