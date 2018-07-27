namespace Demo 
{
    using Artemis;
    using Artemis.Annotations;
    using Microsoft.Xna.Framework;

    ///@EntityTemplate("player")
    public class PlayerTemplate : Object, IEntityTemplate 
    {
        public static void Initialize()
        {
            EntityTemplate.entityTemplates["player"] = typeof(PlayerTemplate);  
        }

        public Artemis.Entity BuildEntity(Artemis.Entity entity, World world, va_list list=null)
        {
            return entity
                .AddComponent(Factory.PlayerComponent())
                .AddComponent(Factory.PositionComponent(0, 0))
                .AddComponent(Factory.ScaleComponent(Vector2(0.8f, 0.8f)))
                .AddComponent(Factory.SpriteComponent("spaceshipspr"));
        }
    }
}