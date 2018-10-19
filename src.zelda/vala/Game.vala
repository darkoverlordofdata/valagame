namespace ZeldaPlatformer
{
    using Artemis;
    using Artemis.Systems;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;
    using Microsoft.Xna.Framework.Input;
    using System.Collections.Generic;
    using System.IO;

    public class Game : Microsoft.Xna.Framework.Game
    {
        public const string Assets = "assets";
        public const int Width = 700;
        public const int Height = 480;
        private GraphicsDeviceManager graphics;
        private SpriteBatch spriteBatch;
        private Texture2D texture;
        private Vector2? position = Vector2.Zero;
        private OrthoCamera camera;

        public Game()
        {
            base();
            // Graphics.
            this.graphics = new GraphicsDeviceManager(this, { 50, 50, Width, Height }); 

            // Content.
            this.Content.RootDirectory = Assets;
            this.camera = new OrthoCamera(Width, Height);

        }

        protected override void Initialize()
        {
            Content.PreLoad("spr/Link");
            spriteBatch = new SpriteBatch(graphics.GraphicsDevice);
            base.Initialize();
        }

        protected override void LoadContent()
        {
            base.LoadContent();

            Content.Load<MetaSprite>("MetaSprite");
                
            texture = Content.Load<Texture2D>("spr/Link/Attack.dds");

            foreach (var key in MetaSprite.MetaSpriteDict.Keys)
            {
                print("%s: %s, %s\n", key, 
                    FArrayToString(MetaSprite.MetaSpriteDict[key].Speed),
                    MetaSprite.MetaSpriteDict[key].Anchor.to_string());
            }

            var js = System.Json.Json.Parse(new FileHandle("assets/Test.json").Read());
            print(System.Json.Json.Stringify(js), null, "\t");
        }

        protected override void Update(GameTime gameTime)
        {
            base.Update(gameTime);
            if (Keyboard.GetState().IsKeyDown(Keys.Escape))
            {
                this.Exit();
            }

        }

        protected override void Draw(GameTime gameTime)
        {
            int width = texture.Width / 5;
            int height = texture.Height;
            int column = 0;

            base.Draw(gameTime);
            this.GraphicsDevice.Clear(Color.CornflowerBlue);


            this.spriteBatch.Begin(camera);
            this.spriteBatch.Draw0(texture, null, 
                { 0, 0, width, height }, 
                { width * column, 0, width, height });
            this.spriteBatch.End();
        }
    }
}