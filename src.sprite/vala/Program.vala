namespace Demo
{
    using System;
    using Microsoft.Xna.Framework;
    using System.Collections.Generic;

    public class Program
    {
        public static void main (string[] args) 
        {
            print("Hello World\n");
            using (new Shmupwarz(), (game) => 
            {
                ((Game)game).Run();
            });
        }
    }
}