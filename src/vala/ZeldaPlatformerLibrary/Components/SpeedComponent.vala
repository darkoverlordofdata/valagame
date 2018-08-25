namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class SpeedComponent : Component
    {
        private Vector2? speed;

        public SpeedComponent(Vector2? speed)
        {
            this.speed = speed;
            this.PreviousPosition = Vector2.Zero;
        }

        public Vector2? Speed
        {
            get { return speed; }
            set { speed = value; }
        }

        public float SpeedX
        {
            get { return speed.X; }
            set { speed.X = value; }
        }

        public float SpeedY
        {
            get { return speed.Y; }
            set { speed.Y = value; }
        }

        public Vector2? PreviousPosition;
    }
}
