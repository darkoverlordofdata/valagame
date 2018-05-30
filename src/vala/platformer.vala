
using GL;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.UI;
using Microsoft.Xna.Framework.Data;
// using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Input;

namespace Demo 
{
    public class Platformer : Microsoft.Xna.Framework.Game 
    {
        public Level CurrentLevel;
        public Character Player;
        public UIButton FrameRate;
        public UIButton Score;
        public UIButton Time;
        public UIButton Victory;
        public UIButton NewGame;
        public Vector2 Camera = Vector2.Zero;
        public int LevelScore = 0;
        public float LevelTime = 0;
        public bool LeftHeld = false;
        public bool RightHeld = false;
        public bool Running = false;
        // private GraphicsDeviceManager graphics;

        static Vector2[] CoinPositions;
        static construct {
            CoinPositions = {
                Vector2(16, 23),  Vector2(33, 28),  Vector2(41, 22),  Vector2(20, 19),  Vector2(18, 28),
                Vector2(36, 20),  Vector2(20, 30),  Vector2(31, 18),  Vector2(45, 23),  Vector2(49, 26),
                Vector2(25, 18),  Vector2(20, 37),  Vector2(44, 32),  Vector2(66, 20),  Vector2(52, 20),
                Vector2(63, 11),  Vector2(52, 12),  Vector2(39, 13),  Vector2(27, 11),  Vector2(73, 20),
                Vector2(65, 29),  Vector2(72, 29),  Vector2(78, 30),  Vector2(78, 20),  Vector2(83, 22),
                Vector2(87, 22),  Vector2(90, 24),  Vector2(94, 19),  Vector2(99, 18),  Vector2(82, 13),
                Vector2(79, 14),  Vector2(106, 22), Vector2(102, 30), Vector2(100, 35), Vector2(93, 27),
                Vector2(88, 34),  Vector2(98, 40),  Vector2(96, 40),  Vector2(94, 40),  Vector2(86, 40),
                Vector2(81, 37),  Vector2(77, 38),  Vector2(72, 34),  Vector2(65, 38),  Vector2(71, 37)
            };
        }

        public Platformer() 
        {
            base();
            Content.RootDirectory = "./Content";

            // graphics = new GraphicsDeviceManager(this); 
            // graphics.PreferredBackBufferWidth = 800;  
            // graphics.PreferredBackBufferHeight = 480;         
        }

        /**
         * Override MonoGame Initialize
         */
        protected override void Initialize()
        {
            base.Initialize();
            Graphic.ViewportSetIcon(URI("Content/logo.bmp"));
            Graphic.ViewportSetTitle("Frodo's Nest");
            Graphic.ViewportSetPosition(120, 30);
            Graphic.ViewportSetSize(800, 480);
        }

        /**
         * Override MonoGame LoadContent
         */
        protected override void LoadContent()
        {
            base.LoadContent();
            Level.Register();
            Coin.Register();
            Character.Register();
            /* Load Assets */
            Content.LoadAll("tiles");
            Content.LoadAll("backgrounds");
            Content.LoadAll("sounds");
            Content.LoadAll("levels");

            Player = Character.Get("Player");

            /* Add some UI elements */
            FrameRate = UIButton.Create("FrameRate");
            FrameRate.Move(Vector2(10, 10));
            FrameRate.Resize(Vector2(30, 25));
            FrameRate.SetLabel(" ");
            FrameRate.Disable();

            Score = UIButton.Create("Score");
            Score.Move(Vector2(50, 10));
            Score.Resize(Vector2(120, 25));
            Score.SetLabel("Score 000000");
            Score.Disable();
                
            Time = UIButton.Create("Time");
            Time.Move(Vector2(180, 10));
            Time.Resize(Vector2(110, 25));
            Time.SetLabel("Time 000000");
            Time.Disable();
                
            Victory = UIButton.Create("Victory");
            Victory.Move(Vector2(365, 200));
            Victory.Resize(Vector2(70, 25));
            Victory.SetLabel("Victory!");
            Victory.Disable();

            NewGame = UIButton.Create("new_game");
            NewGame.Move(Vector2(365, 230));
            NewGame.Resize(Vector2(70, 25));
            NewGame.SetLabel("New Game");
            NewGame.SetOnclick((button, data) => ((Platformer)Instance).ResetGame());
            ResetGame();
        }
        
        
        /**
         * Override MonoGame BeginRun
         */
        protected override void BeginRun()
        {
            base.BeginRun();
            Running = true;
        }

        protected override void Update(GameTime gameTime)
        {

            // Loop.Begin();
            // Events();
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
            Camera = Vector2(Player.Position.X, -Player.Position.Y);
            
            /* Update the FrameRate text */
            FrameRate.SetLabel(Loop.Rate().to_string());
            
            /* Update the Time text */
            if (!Victory.active) {
                LevelTime += (float)Loop.Time();
                Time.label.text = "Time %06i".printf((int)LevelTime);
                Time.label.draw();
            }
            // Loop.End();
            base.Update(gameTime);
        }

        void HandleInput(GameTime gameTime)
        {
            var keyboardState = Keyboard.GetState();
            
            if (keyboardState.IsKeyDown(Keys.Escape)) { Exit(); }
            else if (keyboardState.IsKeyDown(Keys.Left)) { LeftHeld = true; }
            else if (keyboardState.IsKeyDown(Keys.Right)) { RightHeld = true; }
            else if (keyboardState.IsKeyDown(Keys.Up)) 
            {
                Player.Velocity.Y -= 5.0f;
                Player.FlapTimer = 0.15f;
            }
            
            if (keyboardState.IsKeyUp(Keys.Left)) { LeftHeld = false; }
            else if (keyboardState.IsKeyUp(Keys.Right)) { RightHeld = false; }
            
        }

        protected override void Draw(GameTime gameTime)
        {

            /* Clear the screen to a single color */
            GL.Clear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
            
            CurrentLevel.RenderBackground(Camera);
            Player.Render(Camera);
            
            /* Get pointers to all the coins for rendering */
            var numCoins = 0;
            var coins = new Coin[CoinPositions.length];
            EntityManager.Get(coins, out numCoins, Coin.Type); 
            
            for (var i = 0; i < numCoins; i++) {
                coins[i].Render(Camera);
            }
            
            CurrentLevel.RenderTiles(Camera);
            base.Draw(gameTime);

        }


        public void ResetGame() 
        {
            /* Set the starting level to demo.level */
            CurrentLevel = Content.Load<Level>("levels/demo.level");
            LevelScore = 0;
            LevelTime = 0.0f;
            Player.Position = Vector2(20, 20).Mul(TILE_SIZE);
            Player.Velocity = Vector2.Zero;

            /* We can create multiple entities using a name format string like printf */
            EntityManager.Create("coin_id_%i", CoinPositions.length, Coin.Type);
            /* Get an array of pointers to all coin entities */
            var coins = new Coin[CoinPositions.length];
            EntityManager.Get(coins, null, Coin.Type);

            /* Set all the coin initial positions */
            for (var i = 0; i < CoinPositions.length; i++) 
            {
                coins[i].Position = CoinPositions[i].Mul(TILE_SIZE);
            }
            /* Deactivate Victory and new game UI elements */
            Victory.active = false;
            NewGame.active = false;
        }


        public void CollisionDetection() {
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
            
            var bottom1 = Player.Position.Add(Vector2(buffer, TILE_SIZE));
            var bottom2 = Player.Position.Add(Vector2(TILE_SIZE - buffer, TILE_SIZE));
            
            var bottom1Col = TileType.HasCollision(CurrentLevel.TileAt(bottom1));
            var bottom2Col = TileType.HasCollision(CurrentLevel.TileAt(bottom2));
            
            if (bottom1Col || bottom2Col) {
                Player.Position = Player.Position.Add(Vector2(0,-diff.Y));
                Player.Velocity.Y *= -bounce;
            }
            
            /* Top Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var top1 = Player.Position.Add(Vector2(buffer, 0));
            var top2 = Player.Position.Add(Vector2(TILE_SIZE - buffer, 0));
            
            var top1Col = TileType.HasCollision(CurrentLevel.TileAt(top1));
            var top2Col = TileType.HasCollision(CurrentLevel.TileAt(top2));
            
            if (top1Col || top2Col) {
                Player.Position = Player.Position.Add(Vector2(0, TILE_SIZE - diff.Y));
                Player.Velocity.Y *= -bounce;
            }
            
            /* Left Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var left1 = Player.Position.Add(Vector2(0, buffer));
            var left2 = Player.Position.Add(Vector2(0, TILE_SIZE - buffer));
            
            var left1Col = TileType.HasCollision(CurrentLevel.TileAt(left1));
            var left2Col = TileType.HasCollision(CurrentLevel.TileAt(left2));
            
            if (left1Col || left2Col) {
                Player.Position = Player.Position.Add(Vector2(TILE_SIZE - diff.X,0));
                Player.Velocity.X *= -bounce;
            }
            
            /* Right Collision */
            
            diff = Player.Position.FMod(TILE_SIZE);
            
            var right1 = Player.Position.Add(Vector2(TILE_SIZE, buffer));
            var right2 = Player.Position.Add(Vector2(TILE_SIZE, TILE_SIZE - buffer));
            
            var right1Col = TileType.HasCollision(CurrentLevel.TileAt(right1));
            var right2Col = TileType.HasCollision(CurrentLevel.TileAt(right2));
            
            if (right1Col || right2Col) {
                Player.Position = Player.Position.Add(Vector2(-diff.X,0));
                Player.Velocity.X *= -bounce;
            }
            
        }

        public void CollisionDetectionCoins() 
        {
            /* We simply check if the Player intersects with the coins */
            
            var topLeft = Player.Position.Add(Vector2(-TILE_SIZE, -TILE_SIZE));
            var bottomRight = Player.Position.Add(Vector2(TILE_SIZE, TILE_SIZE));
            
            /* Again we collect pointers to all the coin type entities */
            var numCoins = 0;
            var coins = new Coin[CoinPositions.length];
            EntityManager.Get(coins, out numCoins, Coin.Type); 
            
            for (var i = 0; i < numCoins; i++) 
            {
                /* Check if they are within the main char bounding box */
                if ((coins[i].Position.X > topLeft.X) &&
                    (coins[i].Position.X < bottomRight.X) &&
                    (coins[i].Position.Y > topLeft.Y) && 
                    (coins[i].Position.Y < bottomRight.Y)) {
                    
                    /* Remove them from the entity manager and delete */
                    coins[i].Remove();

                    /* Play a nice twinkle sound */
                    // Sound.Play(Asset.Get(URI("Content/sounds/coin.wav")));
                    Sound.Play(Content.LoadAsset("sounds/coin.wav"));
                    
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

    }
}