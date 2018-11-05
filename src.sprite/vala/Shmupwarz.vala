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
        public Rand Random { get; private owned set; }

        World entityWorld;
        SpriteRenderer renderer;
        GraphicsDeviceManager graphics;

        public Shmupwarz()
        {
            base();
            Content.RootDirectory = "/assets";
            graphics = new GraphicsDeviceManager(this, { 50, 50, Width, Height }); 
            Random = new Rand();
        }

        protected override void Initialize()
        {
            renderer = ResourceManager.CreateRenderer(Width, Height);

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
                Pooled.Components//,???

                // background:     typeof(Background),
                // bounds:         typeof(Bounds),
                // bullet:         typeof(Bullet),
                // coloranimation: typeof(ColorAnimation),
                // enemy:          typeof(Enemy),
                // expires:        typeof(Expires),
                // health:         typeof(Health),
                // player:         typeof(Player),
                // position:       typeof(Position),
                // scaleanimation: typeof(ScaleAnimation),
                // soundeffect:    typeof(SoundEffect),
                // sprite:         typeof(Sprite),
                // velocity:       typeof(Velocity)
            );

            base.Initialize();
        }

        protected override void LoadContent()
        {
            base.LoadContent();

            ResourceManager.LoadTexture(@"images/background.png", false, "background");
            ResourceManager.LoadTexture(@"images/bang.png", false, "bang");
            ResourceManager.LoadTexture(@"images/bullet.png", false, "bullet");
            ResourceManager.LoadTexture(@"images/enemy1.png", false, "enemy1");
            ResourceManager.LoadTexture(@"images/enemy2.png", false, "enemy2");
            ResourceManager.LoadTexture(@"images/enemy3.png", false, "enemy3");
            ResourceManager.LoadTexture(@"images/explosion.png", false, "explosion");
            ResourceManager.LoadTexture(@"images/particle.png", false, "particle");
            ResourceManager.LoadTexture(@"images/player.png", false, "player");
            ResourceManager.LoadTexture(@"images/star.png", false, "star");

            EntitySystem.BlackBoard.SetEntry<SpriteRenderer>("Renderer", renderer);
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

        /**
        Destructors -

            ~Shmupwarz()

        probably work better...
         */
        public override void Dispose()
        {
            #if (!__EMSCRIPTEN__)
            renderer.Dispose();
            #endif
            base.Dispose();
        }
    }
}