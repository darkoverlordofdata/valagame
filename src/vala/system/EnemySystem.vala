namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class EnemySystem : VoidEntitySystem
    {
        private Utils.Timer timer1;
        private Utils.Timer timer2;
        private Utils.Timer timer3;

        public EnemySystem(Shmupwarz game)
        {
            var Width = EntitySystem.BlackBoard.GetEntry<int>("Width");
            var Height = EntitySystem.BlackBoard.GetEntry<int>("Height");

            timer1 = new Utils.Timer(2, true){ 
                /* @Override public void */
                Execute = () => {
                    Vector2? pos = new Vector2(game.Random.int_range(0, Width), 50);
                    Vector2? vel = new Vector2(0, 40);
                    World.CreateEntityFromTemplate("enemy", 1, 10, pos, vel)
                        .AddToWorld();
                }
            };

            timer2 = new Utils.Timer(6, true){
                /* @Override public void */
                Execute = () => {
                    Vector2? pos = new Vector2(game.Random.int_range(0, Width), 100);
                    Vector2? vel = new Vector2(0, 30);
                    World.CreateEntityFromTemplate("enemy", 2, 20, pos, vel)
                        .AddToWorld();
                }
            };

            timer3 = new Utils.Timer(12, true){ 
                /* @Override */
                Execute = () => {
                    Vector2? pos = new Vector2(game.Random.int_range(0, Width), 200);
                    Vector2? vel = new Vector2(0, 20);
                    World.CreateEntityFromTemplate("enemy", 3, 60, pos, vel)
                        .AddToWorld();
                }
            };
        }
	
        protected override void ProcessSystem() 
        {
            timer1.Update(World.delta);
            timer2.Update(World.delta);
            timer3.Update(World.delta);
        }
    }
}