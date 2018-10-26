/**
 *
 * based on the Corange version, so this no longer compiles
 */
public static int main (string[] args) {

    // Microsoft.Xna.Framework.Initialize();
    var game = new Demo.Platformer();
    game.Run();
    game.Dispose();
    return 0;
}
