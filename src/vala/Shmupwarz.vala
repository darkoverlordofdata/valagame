namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.UI;
    using Microsoft.Xna.Framework.Input;
    using Microsoft.Xna.Framework.Assets;
    using Microsoft.Xna.Framework.Content;
    using Microsoft.Xna.Framework.Graphics;

    const string Assets = "assets";
    const int Width = 700;
    const int Height = 480;

    public class Shmupwarz : Microsoft.Xna.Framework.Game 
    {
        private World entityWorld;
        private OrthoCamera camera;
        private TextureAtlas atlas;
        private TextureRegion background;
        private SpriteBatch spriteBatch;
        private GraphicsDeviceManager graphics;
        private RenderSystem render;
        private Vector2 scale = new Vector2(0.8f, 0.8f);
        private Vector2 bgScale;
        private float X;
        private float Y;

        public Shmupwarz()
        {
            base();
            Content.RootDirectory = @"./$Assets";
            graphics = new GraphicsDeviceManager(this, { 50, 50, Width, Height }); 
            camera = new OrthoCamera(Width, Height);
        }

        protected override void Initialize()
        {
            Content.PreLoad("images");
            spriteBatch = new SpriteBatch(graphics.GraphicsDevice);
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

            background = atlas.Region("background");

            entityWorld = new World();
            BackgroundTemplate.Initialize();  
            PlayerTemplate.Initialize();  

            render = entityWorld.SetSystem<RenderSystem>(new RenderSystem(this), true);
            entityWorld.SetSystem<InputSystem>(new InputSystem(this));
            entityWorld.Initialize();
            entityWorld.AddEntity(entityWorld.CreateEntityFromTemplate("background", Window.Size.ToVector2().Div(background.Size.ToVector2())));
            entityWorld.AddEntity(entityWorld.CreateEntityFromTemplate("player"));
        }

        protected override void Update(GameTime gameTime)
        {
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
