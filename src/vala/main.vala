using Microsoft.Xna.Framework.Graphics;

public static int main (string[] args) 
{
    Artemis.Initialize();
    var game = new Demo.Shmupwarz();
    game.Run();
    game.Dispose();
    return 0;
}
