using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.UI;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Graphics;
using ValaGame.OpenGL;

namespace Demo 
{
    public class Platformer : Microsoft.Xna.Framework.Game 
    {
        public Level CurrentLevel;
        public Character Player;
        public Button FrameRate;
        public Button Score;
        public Button RunTime;
        public Button Victory;
        public Button NewGame;
        public Vector2 Camera = Vector2.Zero;
        public int LevelScore = 0;
        public float LevelTime = 0;
        public bool LeftHeld = false;
        public bool RightHeld = false;
        public bool Started = false;
        public VertexBatch spriteBatch;
        IntPtr CoinWav;
        Coin[] Coins;
        
        private GraphicsDeviceManager graphics;

        static Vector2[] CoinPositions;
        static construct {
            CoinPositions = {
                new Vector2(16, 23),  new Vector2(33, 28),  new Vector2(41, 22),  new Vector2(20, 19),  new Vector2(18, 28),
                new Vector2(36, 20),  new Vector2(20, 30),  new Vector2(31, 18),  new Vector2(45, 23),  new Vector2(49, 26),
                new Vector2(25, 18),  new Vector2(20, 37),  new Vector2(44, 32),  new Vector2(66, 20),  new Vector2(52, 20),
                new Vector2(63, 11),  new Vector2(52, 12),  new Vector2(39, 13),  new Vector2(27, 11),  new Vector2(73, 20),
                new Vector2(65, 29),  new Vector2(72, 29),  new Vector2(78, 30),  new Vector2(78, 20),  new Vector2(83, 22),
                new Vector2(87, 22),  new Vector2(90, 24),  new Vector2(94, 19),  new Vector2(99, 18),  new Vector2(82, 13),
                new Vector2(79, 14),  new Vector2(106, 22), new Vector2(102, 30), new Vector2(100, 35), new Vector2(93, 27),
                new Vector2(88, 34),  new Vector2(98, 40),  new Vector2(96, 40),  new Vector2(94, 40),  new Vector2(86, 40),
                new Vector2(81, 37),  new Vector2(77, 38),  new Vector2(72, 34),  new Vector2(65, 38),  new Vector2(71, 37)
            };
        }

        public Platformer() 
        {
            base();
            Content.RootDirectory = "./Content";
            graphics = new GraphicsDeviceManager(this); 
            graphics.PreferredBackBufferWidth = 700;  
            graphics.PreferredBackBufferHeight = 480;     
        }

        protected override void LoadContent()
        {
            base.LoadContent();
            
            // Sprites = new SpriteBatch(GraphicsDevice);
            spriteBatch = new VertexBatch(graphics.GraphicsDevice);

            Sdl.Window.SetPosition(Sdl.GetCurrentWindow(), 50, 50);

            /* Register Components */
            Level.Register();
            Coin.Register();
            Character.Register();

            /* Pre-cache the assets */
            Content.LoadFolder("tiles");
            Content.LoadFolder("backgrounds");
            Content.LoadFolder("sounds");
            Content.LoadFolder("levels");
            CoinWav = Content.LoadResource("sounds/coin.wav");

            Player = Character.Get("Player");
            CreateUI();
            var v = ValaGame.OpenGL.GL.GetString(0x1F02);
            print("OpenGL Version %s\n", v);
        }

        protected override void Draw(GameTime gameTime)
        {
            graphics.GraphicsDevice.Clear(Color.Cornsilk);

            if (Started)
            {
                // Sprites.Begin();
                // packs the coins in the case of collision
                var coinCount = EntityManager.Get(Coins, Coin.Type); 

                CurrentLevel.Render(Camera);
                Player.Render(Camera);

                spriteBatch.Begin(Camera);
                for (var i = 0; i < coinCount; i++) {
                    Coins[i].Draw(spriteBatch);
                }
                spriteBatch.End();
            }
            base.Draw(gameTime);
        }
        
        protected override void Update(GameTime gameTime)
        {
            if (Started)
            {
                HandleInput(gameTime);
                if (LeftHeld) {
                    Player.Velocity.X -= 0.1f;
                    Player.FacingLeft = true;
                } else if (RightHeld) {
                    Player.Velocity.X += 0.1f;
                    Player.FacingLeft = false;
                } else {
                    Player.Velocity.X *= 0.95f;
                }
                
                /* Give the Player some gravity speed */
                const float gravity = 0.2f;
                Player.Velocity.Y += gravity;
                
                /* Update moves Position based on Velocity */
                Player.Update();
                
                /* Two phases of collision detection */
                CollisionDetection();
                CollisionDetectionCoins();
                /* Camera follows main character */
                //Camera = new Vector2(Player.Position.X, -Player.Position.Y);
                Camera.X = Player.Position.X;
                Camera.Y = -Player.Position.Y;

            }            
            /* Update the FrameRate text */
            FrameRate.SetLabel(FPS.to_string());
            
            /* Update the RunTime text */
            if (!Victory.active) 
            {
                LevelTime += (float)Time;
                RunTime.label.text = "Time %06.2f".printf(LevelTime);
                // RunTime.label.text = "Time %06i".printf((int)LevelTime);
                RunTime.label.draw();
            }
            base.Update(gameTime);
        }

        public override void Dispose()
        {
            spriteBatch.Dispose();
            base.Dispose();
        }

        void HandleInput(GameTime gameTime)
        {
            var keyboardState = Keyboard.GetState();
            
            if (keyboardState.IsKeyDown(Keys.Escape)) { Exit(); }
            if (keyboardState.IsKeyDown(Keys.Left)) { LeftHeld = true; }
            if (keyboardState.IsKeyDown(Keys.Right)) { RightHeld = true; }
            if (keyboardState.IsKeyDown(Keys.Up)) 
            {
                Player.Velocity.Y -= 5.0f;
                Player.FlapTimer = 0.15f;
            }
            
            if (keyboardState.IsKeyUp(Keys.Left)) { LeftHeld = false; }
            if (keyboardState.IsKeyUp(Keys.Right)) { RightHeld = false; }
        }

        public void ResetGame() 
        {
            /* Set the starting level to demo.level */
            CurrentLevel = Content.LoadAsset<Level>("levels/demo.level");
            LevelScore = 0;
            LevelTime = 0.0f;
            Player.Position = new Vector2(20, 20).Multiply(TILE_SIZE);
            Player.Velocity = Vector2.Zero;

            /* create multiple coin entities */
            EntityManager.Create("coin_id_%i", CoinPositions.length, Coin.Type);
            /* Initialize an array of pointers to all coin entities */
            Coins = new Coin[CoinPositions.length];
            var coinCount = EntityManager.Get(Coins, Coin.Type);

            /* Set all the coin initial positions */
            for (var i = 0; i < coinCount; i++) 
            {
                Coins[i].Initialize(this, CoinPositions[i].Multiply(TILE_SIZE));
            }

            /* Deactivate Victory and new game UI elements */
            Victory.active = false;
            NewGame.active = false;
            Started = true;
        }


        public void CollisionDetection() 
        {
            /*
                Collision is fairly simplistic and looks something like this.
                
                @-----@    We check for collision in those points here which
                @       @   are @ signs. If any are colliding with a solid tile
                |       |   then we shift the Player so that they are no longer
                @       @   colliding with it. Also invert the Velocity.
                @-----@ 
            */
            
            const float buffer = 4;
            const float bounce = 0.5f;
            
            Vector2 diff;
            
            /* Bottom Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var bottom1 = Player.Position.Add(new Vector2(buffer, TILE_SIZE));
            var bottom2 = Player.Position.Add(new Vector2(TILE_SIZE - buffer, TILE_SIZE));
            
            var bottom1Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(bottom1));
            var bottom2Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(bottom2));
            
            if (bottom1Col || bottom2Col) {
                Player.Position = Player.Position.Add(new Vector2(0,-diff.Y));
                Player.Velocity.Y *= -bounce;
            }
            
            /* Top Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var top1 = Player.Position.Add(new Vector2(buffer, 0));
            var top2 = Player.Position.Add(new Vector2(TILE_SIZE - buffer, 0));
            
            var top1Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(top1));
            var top2Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(top2));
            
            if (top1Col || top2Col) {
                Player.Position = Player.Position.Add(new Vector2(0, TILE_SIZE - diff.Y));
                Player.Velocity.Y *= -bounce;
            }
            
            /* Left Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var left1 = Player.Position.Add(new Vector2(0, buffer));
            var left2 = Player.Position.Add(new Vector2(0, TILE_SIZE - buffer));
            
            var left1Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(left1));
            var left2Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(left2));
            
            if (left1Col || left2Col) {
                Player.Position = Player.Position.Add(new Vector2(TILE_SIZE - diff.X,0));
                Player.Velocity.X *= -bounce;
            }
            
            /* Right Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var right1 = Player.Position.Add(new Vector2(TILE_SIZE, buffer));
            var right2 = Player.Position.Add(new Vector2(TILE_SIZE, TILE_SIZE - buffer));
            
            var right1Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(right1));
            var right2Col = CurrentLevel.Tiles.HasCollision(CurrentLevel.TileAt(right2));
            
            if (right1Col || right2Col) {
                Player.Position = Player.Position.Add(new Vector2(-diff.X,0));
                Player.Velocity.X *= -bounce;
            }
        }

        public void CollisionDetectionCoins() 
        {
            /* We simply check if the Player intersects with the coins */
            var topLeft = Player.Position.Add(new Vector2(-TILE_SIZE, -TILE_SIZE));
            var bottomRight = Player.Position.Add(new Vector2(TILE_SIZE, TILE_SIZE));
            
            // packs the coins in the case of collision
            var coinCount = EntityManager.Get(Coins, Coin.Type); 
            
            for (var i = 0; i < coinCount; i++) 
            {
                /* Check if they are within the main char bounding box */
                if ((Coins[i].Position.X > topLeft.X) &&
                    (Coins[i].Position.X < bottomRight.X) &&
                    (Coins[i].Position.Y > topLeft.Y) && 
                    (Coins[i].Position.Y < bottomRight.Y)) {
                    
                    /* Remove them from the entity manager and delete */
                    Coins[i].Remove();

                    /* Play a nice twinkle sound */
                    Sound.Play(CoinWav);
                    
                    /* Add some Score! */
                    LevelScore += 10;
                    
                    /* Update the ui text */
                    Score.label.text = "Score %06i".printf(LevelScore);
                    Score.label.draw();
                }
            }
            
            /* if all the coins are gone and the Victory rectangle isn't disaplayed then show it */
            if ((Coin.Count == 0) && (!Victory.active)) {
                Victory.active = true;
                NewGame.active = true;
            }
        }

        void CreateUI()
        {
            /* Add some UI elements */
            FrameRate = Button.Create("FrameRate");
            FrameRate.Move(new Vector2(10, 10));
            FrameRate.Resize(new Vector2(30, 25));
            FrameRate.SetLabel(" ");
            FrameRate.Disable();

            Score = Button.Create("Score");
            Score.Move(new Vector2(50, 10));
            Score.Resize(new Vector2(120, 25));
            Score.SetLabel("Score 000000");
            Score.Disable();
                
            RunTime = Button.Create("Time");
            RunTime.Move(new Vector2(180, 10));
            RunTime.Resize(new Vector2(110, 25));
            RunTime.SetLabel("Time 000000");
            RunTime.Disable();
                
            Victory = Button.Create("Victory");
            Victory.Move(new Vector2(365, 200));
            Victory.Resize(new Vector2(70, 25));
            Victory.SetLabel("Victory!");
            Victory.Disable();

            NewGame = Button.Create("new_game");
            NewGame.Move(new Vector2(365, 230));
            NewGame.Resize(new Vector2(70, 25));
            NewGame.SetLabel("New Game");
            NewGame.SetOnclick((button, data) => ((Platformer)Instance).ResetGame() );
        }

   }
}
