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

            if(c.alphaAnimate) {
                s.a += c.alphaSpeed * World.delta;
                
                if(s.a > c.alphaMax || s.a < c.alphaMin) {
                    if(c.repeat) {
                        c.alphaSpeed = -c.alphaSpeed;
                    } else {
                        c.alphaAnimate = false;
                    }
                }
            }
        }
    }
}