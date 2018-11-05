namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class RemoveOffscreenSystem : IntervalEntityProcessingSystem
    {

        ComponentMapper<Position> positions;
        ComponentMapper<Bounds> bounds;
        Shmupwarz game;

        public RemoveOffscreenSystem(Shmupwarz game)
        {
		    base(Aspect.GetAspectForAll({ typeof(Velocity), typeof(Position), typeof(Bounds) })
                        .Exclude({ typeof(Player) }), 5);
            this.game = game;
        }

        protected override void Initialize()
        {
            positions = World.GetMapper<Position>();
            bounds = World.GetMapper<Bounds>();
        }

		public override void ProcessEach(Artemis.Entity e)
        {
            // Enemy ships
            if(positions[e].Y - bounds[e].Y > game.Height) 
            {
                e.DeleteFromWorld();
            }
            // stray bullets
            if (positions[e].Y < 0)
            {
                e.DeleteFromWorld();
            }

        }
    }
}