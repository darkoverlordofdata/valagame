
public static int main (string[] args) {

    Microsoft.Xna.Framework.Initialize();
    
    var game = new Demo.Platformer();
    game.Run();
    game.Dispose();
    return 1;

}

