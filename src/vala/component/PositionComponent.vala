namespace Demo 
{
    using Artemis;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework;

    public class PositionComponent : Component
    {
        public Vector2 point;
    }

    public class ScaleComponent : Component
    {
        public Vector2 scale;
    }

    public class PlayerComponent : Component
    {
        public bool active;
    }

    public class BackgroundComponent : Component
    {
        public bool active;
    }
}