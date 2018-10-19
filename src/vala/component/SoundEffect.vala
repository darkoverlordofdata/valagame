namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class SoundEffect : Component
    {
        public enum Effect 
        {
            PEW, ASPLODE, SMALLASPLODE;   
        }

	    public Effect effect;
    }
}