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
            var Width = BlackBoard.GetEntry<int>("Width");
            var Height = BlackBoard.GetEntry<int>("Height");

            timer1 = new Utils.Timer(2, true){ 
                /* @Override public void */
                Execute = () => {
                    World.CreateEntityFromTemplate("enemy", 1, 10, 
                        game.Random.int_range(35, Width-35), 25, 40)
                        .AddToWorld();
                }
            };

            timer2 = new Utils.Timer(6, true){
                /* @Override public void */
                Execute = () => {
                    World.CreateEntityFromTemplate("enemy", 2, 20,
                        game.Random.int_range(86, Width-86), 50, 30)
                        .AddToWorld();
                }
            };

            timer3 = new Utils.Timer(12, true){ 
                /* @Override */
                Execute = () => {
                    World.CreateEntityFromTemplate("enemy", 3, 60, 
                        game.Random.int_range(160, Width-160), 100, 20)
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