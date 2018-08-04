namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class ExpiringSystem : DelayedEntityProcessingSystem
    {

	    private ComponentMapper<Expires> expires;

        public ExpiringSystem(Shmupwarz game)
        {
		    base(Aspect.GetAspectForAll({ typeof(Expires) }));
        }

        protected override void Initialize()
        {
            expires = World.GetMapper<Expires>();
        }
	
    	protected override void ProcessDelta(Artemis.Entity e, float accumulatedDelta) 
        {
            expires[e].delay -= accumulatedDelta;
        }

        protected override void ProcessExpired(Artemis.Entity e) 
        {
            // print("delete %s - %f\n", e.Name, expires[e].delay);
		    e.DeleteFromWorld();
        }

        protected override float GetRemainingDelay(Artemis.Entity e) 
        {
            // print("remaining %f\n", expires[e].delay);
		    return expires[e].delay;
        }

    }
}