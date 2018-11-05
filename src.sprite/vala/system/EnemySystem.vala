namespace Demo 
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Graphics;

    public class EnemySystem : VoidEntitySystem
    {
        Utils.Timer timer1;
        Utils.Timer timer2;
        Utils.Timer timer3;

        public EnemySystem(Shmupwarz game)
        {
            var Width = BlackBoard.GetEntry<int>("Width");
            var Height = BlackBoard.GetEntry<int>("Height");

            timer1 = new Utils.Timer(2, true){ 
                /* @Override public void */
                Execute = () => {
                    World.CreateEntityFromTemplate("enemy", 1, 10, 
                        game.Random.int_range(0, Width), 50, 40)
                        .AddToWorld();
                }
            };

            timer2 = new Utils.Timer(6, true){
                /* @Override public void */
                Execute = () => {
                    World.CreateEntityFromTemplate("enemy", 2, 20,
                        game.Random.int_range(0, Width), 100, 30)
                        .AddToWorld();
                }
            };

            timer3 = new Utils.Timer(12, true){ 
                /* @Override */
                Execute = () => {
                    World.CreateEntityFromTemplate("enemy", 3, 60, 
                        game.Random.int_range(0, Width), 200, 60)
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