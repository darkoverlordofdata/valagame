namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;

    public class InputIntentComponent : Component
    {
        public InputIntentComponent()
        {
            this.Left = false;
            this.Right = false;
            this.Up = false;
            this.Down = false;
            this.Run = false;
        }

        public bool Left { get; set; }
        public bool Right { get; set; }
        public bool Up { get; set; }
        public bool Down { get; set; }
        public bool Run { get; set; }
    }
}