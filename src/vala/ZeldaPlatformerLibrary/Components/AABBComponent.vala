/**
 */
namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class AABBComponent : Component
    {
        public AABBComponent(Quadrangle rectangle)
            
        {
            this.Rectangle = rectangle;
        }

        public Quadrangle Rectangle { get; set; }
    }
}