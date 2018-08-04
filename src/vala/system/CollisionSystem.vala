namespace Demo 
{
    using Artemis;
    using Artemis.Utils;
    using Artemis.Systems;
    using Artemis.Managers;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class CollisionSystem : EntitySystem
    {
        private ComponentMapper<Position> positions;
        private ComponentMapper<Bounds> bounds;
        private ComponentMapper<Health> health;
		private ImmutableBag<Artemis.Entity> enemies;
		private ImmutableBag<Artemis.Entity> bullets;

	    public CollisionSystem(Shmupwarz game) 
        {
		    base(Aspect.GetAspectForAll({ typeof(Position), typeof(Bounds) }));
        }

        protected override void Initialize()
        {
            positions = World.GetMapper<Position>();
            bounds = World.GetMapper<Bounds>();
            health = World.GetMapper<Health>();
			enemies = World.GetManager<GroupManager>().GetEntities("enemy");
			bullets = World.GetManager<GroupManager>().GetEntities("bullet");
        }

        protected override bool CheckProcessing() 
        {
            return true;
	    }

	    protected override void ProcessEntities(ImmutableBag<Artemis.Entity> entities) 
        {
            foreach (var enemy in enemies)
                foreach (var bullet in bullets)
                    if (CollisionExists(bullet, enemy))
                        HandleCollision(bullet, enemy);
        }

        bool CollisionExists(Artemis.Entity e1, Artemis.Entity e2)
        {
			if(e1 == null || e2 == null) {
				return false;
			}
			
			//NPE!!!
			var p1 = positions[e1].xy;
			var p2 = positions[e2].xy;
			
			var b1 = bounds[e1].xy;
			var b2 = bounds[e2].xy;

			return (Vector2(p1.X - p2.X, p1.Y - p2.Y).Length() - b1.Y) < b2.Y;

        }

        void HandleCollision(Artemis.Entity bullet, Artemis.Entity enemy)
        {
            bullet.DeleteFromWorld();
            enemy.DeleteFromWorld();
        }
    }
}