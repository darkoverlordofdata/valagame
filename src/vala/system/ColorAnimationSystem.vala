namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class ColorAnimationSystem : EntityProcessingSystem
    {
        private ComponentMapper<Sprite> sprite;
        private ComponentMapper<ColorAnimation> animation;

        public ColorAnimationSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({
                    typeof(Sprite), 
                    typeof(ColorAnimation) 
            }));
        }

        protected override void Initialize()
        {
            sprite = World.GetMapper<Sprite>();
            animation = World.GetMapper<ColorAnimation>();
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var s = sprite[e];
            var c = animation[e];

            if(c.AlphaAnimate) {
                s.A += c.AlphaSpeed * World.delta;
                
                if(s.A > c.AlphaMax || s.A < c.AlphaMin) {
                    if(c.Repeat) {
                        c.AlphaSpeed = -c.AlphaSpeed;
                    } else {
                        c.AlphaAnimate = false;
                    }
                }
            }
        }
    }
}