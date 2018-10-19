namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class PositionComponent : Component
    {
        public PositionComponent(Vector2? position)
        {
            this.Position = position;
        }

        public Vector2? Position { get; set; }
    }
}