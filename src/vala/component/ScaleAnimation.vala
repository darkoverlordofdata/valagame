namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class ScaleAnimation : Component
    {
        public float Min;
        public float Max;
        public float Speed;
        public bool Repeat;
        public bool Active;

        /// <summary>Initializes a new instance of the <see cref="VelocityComponent" /> class.</summary>
        public ScaleAnimation.Empty()
        {
            this(0f, 0f, 0f, false, false);
        }

        /// <summary>Initializes a new instance of the <see cref="BoundsComponent"/> class.</summary>
        /// <param name="min">The min.</param>
        /// <param name="max">The max.</param>
        /// <param name="speed">The speed.</param>
        /// <param name="repeat">The repeat.</        
        /// <param name="active">The active.</param>
        public ScaleAnimation(float min, float max, float speed, bool repeat, bool active)
        {
            Min = min;
            Max = max;
            Speed = speed;
            Repeat = repeat;
            Active = active;

        }

        public void Animate(Sprite sprite, float delta)
        {
            if (Active) {
                sprite.X += Speed * delta;
                sprite.Y = sprite.X;

                if (sprite.X > Max) {
                    sprite.X = Max;
                    Active = false;
                } else if (sprite.X < Min) {
                    sprite.X = Min;
                    Active = false;
                }
            }

        }

    }
}