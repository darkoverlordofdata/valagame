namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class MovementSystem : EntityProcessingSystem
    {
        private ComponentMapper<Position> positions;
        private ComponentMapper<Velocity> velocitys;

        public MovementSystem(Game game)
        {
		    base(Aspect.GetAspectForAll({ typeof(Position), typeof(Velocity) }));
        }

        protected override void Initialize()
        {
            positions = World.GetMapper<Position>();
            velocitys = World.GetMapper<Velocity>();
        }

		public override void ProcessEach(Artemis.Entity e)
        {
            Position position = positions[e];
            Velocity velocity = velocitys[e];
            
            if (velocity == null) {
                return;
            }
            // position.xy = position.xy.Add(velocity.xy.Multiply(World.delta));

            position.xy.X += velocity.xy.X * World.delta;
            position.xy.Y += velocity.xy.Y * World.delta;


        }

    }
}