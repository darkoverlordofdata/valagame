namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    using Microsoft.Xna.Framework.Content;

    public class ContentManagerComponent : Component
    {
        public ContentManagerComponent(ContentManager contentManager)
        {
            this.ContentManager = contentManager;
        }

        public ContentManager ContentManager { get; set; }
    }
}