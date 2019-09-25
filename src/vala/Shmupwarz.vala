namespace Demo 
{
    using Artemis;
    using Artemis.Managers;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Content;
    using Microsoft.Xna.Framework.Graphics;

    public class Shmupwarz : Microsoft.Xna.Framework.Game 
    {
        public const int Width = 700;
        public const int Height = 480;

        private World entityWorld;
        private OrthoCamera camera;
        private SpriteBatch2D? spriteBatch;
        private GraphicsDeviceManager graphics;
        public Rand Random { get; private owned set; default = new Rand(); }

        public Shmupwarz()
        {
            base();
            Content.RootDirectory = "assets";
            graphics = new GraphicsDeviceManager(this, { 0, 0, Width, Height }); 
            camera = new OrthoCamera(Width, Height);
        }

        protected override void Initialize()
        {
            // print("(%d,%d)\n", graphics.PreferredBackBufferWidth, graphics.PreferredBackBufferHeight);
            spriteBatch = ResourceManager.CreateSpriteBatch2D(graphics);
            
            Register<EntityTemplate>
            (
                EntityTemplate.Templates,

                background:     typeof(BackgroundTemplate),
                bullet:         typeof(BulletTemplate),
                enemy:          typeof(EnemyTemplate),
                explosion:      typeof(ExplosionTemplate),
                particle:       typeof(ParticleTemplate),
                player:         typeof(PlayerTemplate)
            );  

            Register<Component>
            (
                Pooled.Components,

                background:     typeof(Background),
                bounds:         typeof(Bounds),
                bullet:         typeof(Bullet),
                coloranimation: typeof(ColorAnimation),
                enemy:          typeof(Enemy),
                expires:        typeof(Expires),
                health:         typeof(Health),
                player:         typeof(Player),
                position:       typeof(Position),
                scaleanimation: typeof(ScaleAnimation),
                soundeffect:    typeof(SoundEffect),
                sprite:         typeof(Sprite),
                velocity:       typeof(Velocity)
            );

            base.Initialize();
        }

        protected override void LoadContent()
        {
            base.LoadContent();

            var atlas = new TextureAtlas(Content, "images/assets.atlas");
            
            EntitySystem.BlackBoard.SetEntry<TextureAtlas>("Atlas", atlas);
            EntitySystem.BlackBoard.SetEntry<float?>("EnemyInterval", 420f);
            EntitySystem.BlackBoard.SetEntry<OrthoCamera>("OrthoCamera", camera);
            EntitySystem.BlackBoard.SetEntry<SpriteBatch2D?>("SpriteBatch", spriteBatch);
            EntitySystem.BlackBoard.SetEntry<ContentManager>("ContentManager", Content);
            EntitySystem.BlackBoard.SetEntry<GraphicsDeviceManager>("GraphicsDeviceManager", graphics);
            EntitySystem.BlackBoard.SetEntry<Shmupwarz>("game", this);
            EntitySystem.BlackBoard.SetEntry<int>("Width", Width);
            EntitySystem.BlackBoard.SetEntry<int>("Height", Height);

            entityWorld = new World();
            
		    entityWorld.SetManager(new GroupManager());
            entityWorld.SetSystem<RenderSystem>(new RenderSystem(this), true);
            entityWorld.SetSystem<InputSystem>(new InputSystem(this));
            entityWorld.SetSystem<EnemySystem>(new EnemySystem(this));
            entityWorld.SetSystem<MovementSystem>(new MovementSystem(this));
            entityWorld.SetSystem<ExpiringSystem>(new ExpiringSystem(this));
            entityWorld.SetSystem<RemoveOffscreenSystem>(new RemoveOffscreenSystem(this));
            entityWorld.SetSystem<CollisionSystem>(new CollisionSystem(this));
            entityWorld.SetSystem<ScaleAnimationSystem>(new ScaleAnimationSystem(this));

            entityWorld.Initialize();
            entityWorld.AddEntity(entityWorld.CreateEntityFromTemplate("background"));
            entityWorld.AddEntity(entityWorld.CreateEntityFromTemplate("player"));
        }

        protected override void Update(GameTime gameTime)
        {
            entityWorld.SetDelta((float)gameTime.ElapsedGameTime.TotalSeconds);
            entityWorld.Update();
            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            entityWorld.Draw();
            base.Draw(gameTime);
        }

        public override void Dispose()
        {
            spriteBatch.Dispose();
            base.Dispose();
        }
    }
}