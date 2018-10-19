namespace ZeldaPlatformerLibrary.Components
{
    using Artemis;
    using Artemis.Managers;
    using System.Collections.Generic;

    public class FSMComponent : Component
    {
        public FSMComponent(Dictionary<string, Component> components, Dictionary<string, ArrayList<string>> states, Entity entity, string stateName)
        {
            this.Components = (Dictionary<string, Component>)components;
            this.States = (Dictionary<string, ArrayList<string>>)states;
            this.CurrentState = new ArrayList<string>();
            this.SetState(entity, stateName);
        }

        public Dictionary<string, Component> Components { get; set; }
        public Dictionary<string, ArrayList<string>> States { get; set; }
        public ArrayList<string> CurrentState { get; set; }

        public void SetState(Entity entity, string stateName)
        {
            ArrayList<string> newState = this.States[stateName];

            if (this.CurrentState == newState)
            {
                return;
            }

            foreach (string componentName in this.CurrentState)
            {
                // if (newState.IndexOf(componentName) == -1)
                // {
                //     entity.RemoveComponent(ComponentTypeManager.GetTypeFor(this.Components[componentName].GetType()));
                // }
            }

            foreach (string componentName in newState)
            {
                if (this.CurrentState.IndexOf(componentName) == -1)
                {
                    entity.AddComponent(this.Components[componentName]);
                }
            }

            this.CurrentState = newState;
        }
    }
}