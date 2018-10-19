namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;

    public class LinkRunStateComponent : Component
    {
        public LinkRunStateComponent(float maxRunSpeed)
        {
            this.MaxRunSpeed = maxRunSpeed;
        }

        public float MaxRunSpeed { get; set; }
    }
}