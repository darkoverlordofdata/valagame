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
            base(Aspect.GetAspectFor({ typeof(Sprite), typeof(ScaleAnimation) }));
        }

        protected override void Initialize()
        {
            sprite = World.GetMapper<Sprite>();
            animation = World.GetMapper<ScaleAnimation>();
        }

        protected override void ProcessEach(Artemis.Entity e)
        {
            animation[e].Animate(sprite[e], World.delta);
        }
    }
}