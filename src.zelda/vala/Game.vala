namespace ZeldaPlatformer
{
    using Artemis;
    // using Artemis.Interface;
    // using Artemis.System;
    // using FuncWorks.XNA.XTiled;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;
    using Microsoft.Xna.Framework.Input;
    using System.Collections.Generic;

    public class Game : Microsoft.Xna.Framework.Game
    {
        public const string Assets = "assets";
        public const int Width = 700;
        public const int Height = 480;
        private GraphicsDeviceManager graphics;
        private SpriteBatch spriteBatch;

        public Game()
        {
            base();
            // Graphics.
            this.graphics = new GraphicsDeviceManager(this, { 50, 50, Width, Height }); 

            // Content.
            this.Content.RootDirectory = Assets;

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

            foreach (var key in MetaSprite.MetaSpriteDict.Keys)
            {
                print("%s: %s, %s\n", key, 
                    FArrayToString(MetaSprite.MetaSpriteDict[key].Speed),
                    MetaSprite.MetaSpriteDict[key].Anchor.to_string());
            }
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
            base.Draw(gameTime);
            this.GraphicsDevice.Clear(Color.CornflowerBlue);

            // this.spriteBatch.Begin();
            // this.world.Draw();
            // this.spriteBatch.End();
        }
    }
}