namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework;

    ///@EntityTemplate("background")
    public class BackgroundTemplate : Object, IEntityTemplate 
    {
        public static void Initialize()
        {
            EntityTemplate.entityTemplates["background"] = typeof(BackgroundTemplate);  
        }

        public Artemis.Entity BuildEntity(Artemis.Entity entity, World world, va_list list)
        {
            Vector2 scale = list.arg<Vector2>();

            return entity
                .AddComponent(Factory.BackgroundComponent())
                .AddComponent(Factory.ScaleComponent(scale))
                .AddComponent(Factory.SpriteComponent("background"));
        }
    }
}
