namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class Position : Component
    {
        public float X;
        public float Y;

        /// <summary>Initializes a new instance of the <see cref="PositionComponent" /> class.</summary>
        public Position.Empty()
        {
            this(0f, 0f);
        }

        /// <summary>Initializes a new instance of the <see cref="BoundsComponent"/> class.</summary>
        /// <param name="x">The x.</param>
        /// <param name="y">The y.</param>
        public Position(float x=0f, float y=0f)
        {
            X = x;
            Y = y;
        }
    }
}