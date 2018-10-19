namespace Demo
{
    using System;
    using Microsoft.Xna.Framework;
    using System.Collections.Generic;
    
    public class Program
    {
        public static void main (string[] args) 
        {
            println("Sdl.GetPerformanceFrequency() = %llu", Sdl.GetPerformanceFrequency());
            println("Sdl.GetPerformanceCounter() = %llu", Sdl.GetPerformanceCounter());
            var t = new TimeVal();
            uint64 ts = t.tv_sec;
            uint64 us = t.tv_usec;

            var t1 = (ts * 1000000L) + us;
            println("%llu", t1);
            println("%ld:%ld", t.tv_sec, t.tv_usec);

            using (new Shmupwarz(), (game) => 
            {
                ((Game)game).Run();
            });
        }
    }

}