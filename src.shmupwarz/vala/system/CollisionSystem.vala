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
        private float? small = 0.25f;
        private float? large = 0.75f;

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
			if(e1 == null || e2 == null) return false;
			
            Vector2 p1 = { positions[e1].X, positions[e1].Y };
            Vector2 p2 = { positions[e2].X, positions[e2].Y };
			
            return (p1.Sub(p2).Length() - bounds[e1].Y) < bounds[e2].Y;
        }

        void HandleCollision(Artemis.Entity bullet, Artemis.Entity enemy)
        {
            var pos = positions[bullet];
            
            World.CreateEntityFromTemplate("explosion", (int)pos.X, (int)pos.Y, small)
                .AddToWorld();
            
            for (var i=0; i<4; i++)
                World.CreateEntityFromTemplate("particle", (int)pos.X, (int)pos.Y)
                    .AddToWorld();

            bullet.DeleteFromWorld();

            // var points = health[enemy].points - 2;

            health[enemy].AddDamage(2);
            if (!health[enemy].IsAlive)
            {
                World.CreateEntityFromTemplate("explosion", (int)pos.X, (int)pos.Y, large)
                    .AddToWorld();
                enemy.DeleteFromWorld();
            }
        }
    }
}