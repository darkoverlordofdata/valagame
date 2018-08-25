namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    using System;

    public class EventSenderComponent : Component
    {
        public EventSenderComponent()
        {
        }

        public GenericEventHandler GenericEvent;

        public void Trigger<T>(Entity entity, T e) // where T: EventArg
        {
            GenericEventHandler handler = this.GenericEvent;

            if (handler != null)
            {
                handler(entity, typeof(T), e);
            }
        }

        public delegate void GenericEventHandler<T>(Entity entity, Type eventType, T e);
    }
}