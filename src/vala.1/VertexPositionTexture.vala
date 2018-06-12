
namespace Microsoft.Xna.Framework.Graphics
{
    public struct VertexPositionTexture 
    {
        public Vector3 Position;
        public Vector2 TextureCoordinate;

        public VertexPositionTexture(Vector3? position=null, Vector2? textureCoordinate=null)
        {
            Position = position ?? Vector3.Zero;
            TextureCoordinate = textureCoordinate ?? Vector2.Zero;
        }
		
        public int GetHashCode()
        {
            var hashCode = Position.GetHashCode();
            hashCode = (hashCode * 397) ^ TextureCoordinate.GetHashCode();
            return hashCode;
        }

        public string ToString()
        {
            return @"{{Position: $Position TextureCoordinate: $TextureCoordinate }}";
        }

        public bool Equals(VertexPositionColorTexture obj)
        {
            return (Position.Equals(obj.Position) && TextureCoordinate.Equals(TextureCoordinate));
        }
    }
}
