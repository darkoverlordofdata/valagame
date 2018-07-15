using ValaGame.OpenGL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.UI;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Assets;
using Microsoft.Xna.Framework.Graphics;

namespace Demo 
{
    const string Assets = "assets";

    public class Shmupwarz : Microsoft.Xna.Framework.Game 
    {
        private GraphicsDeviceManager graphics;
        public Texture2D[] Sprite;
        public Vector2 Position;
        public Vector2 Size;
        public VertexBatch spriteBatch;

        public Shmupwarz()
        {
            base();
            Content.RootDirectory = @"./$Assets";
            graphics = new GraphicsDeviceManager(this); 
            graphics.PreferredBackBufferWidth = 700;  
            graphics.PreferredBackBufferHeight = 480;     
            Sprite = new Texture2D[1];
            Position = Vector2.Zero;
            var rectangle = Game.Instance.Window.ClientBounds;
            Size = Vector2(rectangle.Width, rectangle.Height);
        }

        protected override void LoadContent()
        {
            base.LoadContent();
            spriteBatch = new VertexBatch(graphics.GraphicsDevice);
            Sdl.Window.SetPosition(Sdl.GetCurrentWindow(), 50, 50);
            Content.LoadFolder("images");
            // Content.LoadFolder("sounds");
            // Content.LoadFolder("fonts");
            Sprite[0] = Game.Instance.Content.Load<Texture2D>("images/background.dds");
            Sprite[1] = Game.Instance.Content.Load<Texture2D>("images/assets.dds");
        }

        protected override void Draw(GameTime gameTime)
        {
            graphics.GraphicsDevice.Clear(Color.CadetBlue);
            GL.Use2DCamera();
            GL.BindTexture(TextureTarget.Texture2D, Sprite[0].Handle);
            GL.Draw(Position, Size);

            // spriteBatch.Begin();
            // Sprite[1].Draw(spriteBatch, Position, null, { 2, 505, 512, 512 });
            // spriteBatch.End();

        }

        protected override void Update(GameTime gameTime)
        {
            HandleInput(gameTime);
        }

        public override void Dispose()
        {
            base.Dispose();
        }

        void HandleInput(GameTime gameTime)
        {
            var keyboardState = Keyboard.GetState();
            
            if (keyboardState.IsKeyDown(Keys.Escape)) { Exit(); }
        }
    }
}
