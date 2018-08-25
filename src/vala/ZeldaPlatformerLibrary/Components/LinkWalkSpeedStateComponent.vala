namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;

    public class LinkWalkSpeedStateComponent : Component
    {
        public LinkWalkSpeedStateComponent(float maxWalkSpeed)
        {
            this.MaxWalkSpeed = maxWalkSpeed;
        }

        public float MaxWalkSpeed { get; set; }
    }
}