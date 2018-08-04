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
        public const string Assets = "assets";
        public const int Width = 700;
        public const int Height = 480;

        private World entityWorld;
        private OrthoCamera camera;
        private TextureAtlas atlas;
        private SpriteBatch spriteBatch;
        private GraphicsDeviceManager graphics;
        private RenderSystem render;
        private uint64 freq;
        private double currentTime;

        public Rand Random { get; owned construct; default=new Rand(); }

        public Shmupwarz()
        {
            base();
            Content.RootDirectory = @"./$Assets";
            graphics = new GraphicsDeviceManager(this, { 50, 50, Width, Height }); 
            camera = new OrthoCamera(Width, Height);
		    freq = Sdl.GetPerformanceFrequency();
        }

        protected override void Initialize()
        {
            Content.PreLoad("images");
            spriteBatch = new SpriteBatch(graphics.GraphicsDevice);

            Register<IEntityTemplate>
            (
                EntityTemplate.Templates,

                background: typeof(BackgroundTemplate),
                bullet:     typeof(BulletTemplate),
                enemy:      typeof(EnemyTemplate),
                explosion:  typeof(ExplosionTemplate),
                particle:   typeof(ParticleTemplate),
                player:     typeof(PlayerTemplate)
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

            atlas = Content.Load<TextureAtlas>("images/assets.atlas");
            EntitySystem.BlackBoard.SetEntry<TextureAtlas>("Atlas", atlas);
            EntitySystem.BlackBoard.SetEntry<float?>("EnemyInterval", 420f);
            EntitySystem.BlackBoard.SetEntry<OrthoCamera>("OrthoCamera", camera);
            EntitySystem.BlackBoard.SetEntry<SpriteBatch>("SpriteBatch", spriteBatch);
            EntitySystem.BlackBoard.SetEntry<ContentManager>("ContentManager", Content);
            EntitySystem.BlackBoard.SetEntry<GraphicsDeviceManager>("GraphicsDeviceManager", graphics);
            EntitySystem.BlackBoard.SetEntry<Shmupwarz>("game", this);
            EntitySystem.BlackBoard.SetEntry<int>("Width", Width);
            EntitySystem.BlackBoard.SetEntry<int>("Height", Height);

            entityWorld = new World();
		    entityWorld.SetManager(new GroupManager());
            render = entityWorld.SetSystem<RenderSystem>(new RenderSystem(this), true);
            entityWorld.SetSystem<InputSystem>(new InputSystem(this));
            entityWorld.SetSystem<EnemySystem>(new EnemySystem(this));
            entityWorld.SetSystem<MovementSystem>(new MovementSystem(this));
            entityWorld.SetSystem<ExpiringSystem>(new ExpiringSystem(this));
            entityWorld.SetSystem<RemoveOffscreenSystem>(new RemoveOffscreenSystem(this));
            entityWorld.SetSystem<CollisionSystem>(new CollisionSystem(this));
            entityWorld.Initialize();
            entityWorld.AddEntity(entityWorld.CreateEntityFromTemplate("background", Window.Size.ToVector2()));
            entityWorld.AddEntity(entityWorld.CreateEntityFromTemplate("player"));

            currentTime = (double)Sdl.GetPerformanceCounter()/freq;
        }

        protected override void Update(GameTime gameTime)
        {
		    var newTime = (double)Sdl.GetPerformanceCounter()/freq;
		    var delta = newTime - currentTime;
		    currentTime = newTime;

            entityWorld.SetDelta((float)delta);
            entityWorld.Process();
            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            render.Process();
            base.Draw(gameTime);
        }

        public override void Dispose()
        {
            spriteBatch.Dispose();
            base.Dispose();
        }
    }
}