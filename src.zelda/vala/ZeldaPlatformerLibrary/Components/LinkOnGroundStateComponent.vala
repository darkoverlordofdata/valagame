namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;

    public class LinkOnGroundStateComponent : Component
    {
        public LinkOnGroundStateComponent(float accel, float jumpForce)
        {
            this.Accel = accel;
            this.JumpForce = jumpForce;
        }

        public float Accel { get; set; }
        public float JumpForce { get; set; }
    }
}