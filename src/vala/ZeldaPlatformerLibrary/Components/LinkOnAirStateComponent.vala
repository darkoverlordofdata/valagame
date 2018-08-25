namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;

    public class LinkOnAirStateComponent : Component
    {
        public LinkOnAirStateComponent(float maxVerticalSpeed, float gravity)
        {
            this.MaxVerticalSpeed = maxVerticalSpeed;
            this.Gravity = gravity;
        }

        public float MaxVerticalSpeed { get; set; }
        public float Gravity { get; set; }
    }
}