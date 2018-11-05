namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class MovementSystem : EntityProcessingSystem
    {
        ComponentMapper<Position> positions;
        ComponentMapper<Velocity> velocitys;

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

            position.X += velocity.X * World.delta;
            position.Y += velocity.Y * World.delta;

        }
    }
}