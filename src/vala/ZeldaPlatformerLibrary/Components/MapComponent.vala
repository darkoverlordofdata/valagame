namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    // using FuncWorks.XNA.XTiled;

    public class Map : Object
    {
        
    }
    public class MapComponent : Component
    {
        public MapComponent(Map map)
        {
            this.Map = map;
        }

        public Map Map { get; set; }
    }
}