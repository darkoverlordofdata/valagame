namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class SoundEffectSystem : EntityProcessingSystem
    {
        public SoundEffectSystem()
        {
		    base(Aspect.GetAspectForAll({ typeof(SoundEffect) } ));
        }

		public override void ProcessEach(Artemis.Entity e)
        {

        }

    }
}