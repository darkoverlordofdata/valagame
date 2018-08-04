namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class ScaleAnimationSystem : EntityProcessingSystem
    {
        private ComponentMapper<Sprite> sprite;
        private ComponentMapper<ScaleAnimation> animation;

        public ScaleAnimationSystem(Shmupwarz game)
        {
            base(Aspect.GetAspectFor({
                    typeof(ScaleAnimation) 
            }));
        }

        protected override void Initialize()
        {
            sprite = World.GetMapper<Sprite>();
            animation = World.GetMapper<ScaleAnimation>();
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            var a = animation[e];

            if (a.active) {
                var s = sprite[e];

                s.scale.X += a.speed * World.delta;
                s.scale.Y = s.scale.X;

                if (s.scale.X > a.max) {
                    s.scale.X = a.max;
                    a.active = false;
                } else if (s.scale.X < a.min) {
                    s.scale.X = a.min;
                    a.active = false;
                }
            }
        }
    }
}