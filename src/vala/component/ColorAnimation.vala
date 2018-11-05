namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class ColorAnimation : Component
    {
        public float RedMin;
        public float RedMax;
        public float RedSpeed;
        public float GreenMin;
        public float GreenMax;
        public float GreenSpeed;
        public float BlueMin;
        public float BlueMax;
        public float BlueSpeed;
        public float AlphaMin;
        public float AlphaMax;
        public float AlphaSpeed;
        public bool RedAnimate;
        public bool GreenAnimate;
        public bool BlueAnimate;
        public bool AlphaAnimate;
        public bool Repeat;

        /// <summary>Initializes a new instance of the <see cref="ColorAnimation" /> class.</summary>
        public ColorAnimation.Empty()
        {
            this(0f, 0f, 0f, false, false);
        }

        /// <summary>Initializes a new instance of the <see cref="ColorAnimation"/> class.</summary>
        /// <param name="alphaAnimate">The active.</param>
        /// <param name="alphaMin">The min.</param>
        /// <param name="alphaMax">The max.</param>
        /// <param name="alphaSpeed">The speed.</param>
        /// <param name="repeat">The repeat.</param>        
        public ColorAnimation(float min, float max, float speed, bool repeat, bool active)
        {
            AlphaAnimate = active;
            AlphaSpeed = speed;
            AlphaMin = min;
            AlphaMax = max;
            Repeat = repeat;
        }

    }
}