
public static int main (string[] args) {

    print("DarkoGame Version = %1d.%1d.%1d\n", Dark.MajorVersion, Dark.MinorVersion, Dark.BuildVersion);

    var z2 = new Dark.Object();
    var z1 = new Dark.Rect(10, 10, 100, 200);
    var z3 = z1;
    print("z2(%s) = %lu\n", z2.ToString(), z2.GetHashCode());
    print("z1 = %lu\n", z1.GetHashCode());
    print("z1(%s) = %lu\n", z1.ToString(), z1.GetHashCode());

    if (Dark.Object.ReferenceEquals(z1, z2))
        print("z1 equal to z2\n");
    else
        print("z1 not equal to z2\n");

    if (z3.Equals(z1))
        print("z1 equal to z3\n");
    else
        print("z1 not equal to z3\n");

    // return 0;

    Microsoft.Xna.Framework.Initialize();

    var game = new Demo.Platformer();
    game.Run();
    game.Dispose();
    return 1;
}

