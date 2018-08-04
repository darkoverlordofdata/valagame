using System;
using Microsoft.Xna.Framework;

namespace Demo
{
    public class Program
    {
        public static int main (string[] args) 
        {
            using (new Shmupwarz(), (game)=> {
                
                ((Game)game).Run();
                
            });
            return 0;
        }
    }
}

            // Register<Component>
            // (
            //     Pooled.Components,

            //     position:   typeof(PositionComponent),
            //     sprite:     typeof(SpriteComponent),
            //     scale:      typeof(ScaleComponent),
            //     player:     typeof(PlayerComponent),
            //     background: typeof(BackgroundComponent)
            // );


