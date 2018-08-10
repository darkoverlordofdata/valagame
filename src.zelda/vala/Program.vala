namespace ZeldaPlatformer
{
    using System;
    using Microsoft.Xna.Framework;
    using System.Collections.Generic;
    using System.IO;

    public class Program
    {
        public static void main(string[] args)
        {
            using (new Game(), (game) => 
            {
                ((Game)game).Run();
            });
        }
    }
}

public string FArrayToString(float[] f)
{
    var s  = new StringBuilder("{");
    var b = 0;
    var e = f.length-1;
    foreach (var f1 in f)
    {
        s.append(f1.to_string());
        if (b++ < e)
            s.append(", ");
    }
    s.append("}");
    return s.str;
}

