namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;

    public class BinaryDirectionComponent : Component
    {
        public BinaryDirectionComponent()
        {
            this.Direction = BinaryDirection.Right;
        }

        public BinaryDirection Direction { get; set; }
    }

    public enum BinaryDirection
    {
        Left = -1,
        Right = 1
    }
}