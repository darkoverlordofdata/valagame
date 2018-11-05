namespace Demo 
{
    using Artemis;
    using Microsoft.Xna.Framework;

    public class Health : Component
    {
        // public float points = 0f;
        // public float max = 0f;

        /// <summary>Initializes a new instance of the <see cref="HealthComponent"/> class.</summary>
        public Health.Empty()
        {
            this(0f);
        }

        /// <summary>Initializes a new instance of the <see cref="HealthComponent"/> class.</summary>
        /// <param name="points">The points.</param>
        public Health(float points)
        {
            this.Points = this.MaximumHealth = points;
        }

        /// <summary>Gets or sets the health points.</summary>
        /// <value>The Points.</value>
        public float Points { get; set; }

        /// <summary>Gets the health percentage.</summary>
        /// <value>The health percentage.</value>
        public double HealthPercentage
        {
            get
            {
                return Math.round(this.Points / this.MaximumHealth * 100f);
            }
        }

        /// <summary>Gets a value indicating whether is alive.</summary>
        /// <value><see langword="true" /> if this instance is alive; otherwise, <see langword="false" />.</value>
        public bool IsAlive
        {
            get
            {
                return this.Points > 0;
            }
        }
        /// <summary>Gets the maximum health.</summary>
        /// <value>The maximum health.</value>
        public float MaximumHealth { get; private set; }

        /// <summary>The add damage.</summary>
        /// <param name="damage">The damage.</param>
        public void AddDamage(int damage)
        {
            this.Points -= damage;
            if (this.Points < 0)
            {
                this.Points = 0;
            }
        }

    }
}