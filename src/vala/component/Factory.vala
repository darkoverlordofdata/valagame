namespace Demo 
{
    using Artemis;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class Factory : Object
    {
        public static PositionComponent PositionComponent(int x, int y)
        {
            var c = new Demo.PositionComponent();
            c.point = new Vector2(x, y);
            return c;
        }

        public static ScaleComponent ScaleComponent(Vector2 scale)
        {
            var c = new Demo.ScaleComponent();
            c.scale = new Vector2(scale.X, scale.Y);
            return c;
        }

        public static SpriteComponent SpriteComponent(string name)
        {
            var atlas = EntitySystem.BlackBoard.GetEntry<TextureAtlas>("Atlas");
            var c = new Demo.SpriteComponent();
            c.name = name;
            c.region = atlas.Region(name);
            return c;
        }

        public static PlayerComponent PlayerComponent()
        {
            var c = new Demo.PlayerComponent();
            c.active = true;
            return c;
        }

        public static BackgroundComponent BackgroundComponent()
        {
            var c = new Demo.BackgroundComponent();
            c.active = true;
            return c;
        }
    }



}