using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Microsoft.Xna.Framework.Graphics 
{
    public class VertexBatch : Object, IDisposable
    {
        private const Vector2 UnitY = { 0, 1 };
        private const Vector2 UnitX = { 1, 0 };

        private Texture2D? _texture;
        private Vector2 _camera;
        private bool _beginCalled;
        private VertexBatcher _batcher;
		private SpriteSortMode _sortMode;

        public VertexBatch(GraphicsDevice graphicsDevice)
        {
            _beginCalled = false;
            _batcher = new VertexBatcher(graphicsDevice);
        }

        public void Begin(
            Vector2 camera = Vector2.Zero, 
            SpriteSortMode sortMode = SpriteSortMode.Deferred)
        {
            if (_beginCalled)
                throw new Exception.InvalidOperationException("Begin cannot be called again until End has been successfully called.");

            _sortMode = sortMode;
            _camera = camera;
            _beginCalled = true;
        }

        public void Draw(
            Texture2D texture, 
            Vector2? position = null, 
            Quadrangle? destinationRectangle = null,
            Quadrangle? sourceRectangle = null,
            Vector2? origin = null,
            float rotation = 0f,
            Vector2? scale = null,
            Color? color = null,
			SpriteEffects effects = SpriteEffects.None,
            float layerDepth = 0f)
        {
            CheckValid(texture);
            _texture = texture;
            position = position ?? Vector2.Zero;
            destinationRectangle = destinationRectangle ?? new Quadrangle((int)position.X, (int)position.Y, texture.Width, texture.Height);
            sourceRectangle = sourceRectangle ?? new Quadrangle(0, 0, texture.Width, texture.Height);
            origin = origin ?? Vector2.Zero;
            scale = scale ?? Vector2.One;
            color = color ?? Color.White;
            var texCoordTL = UnitY;
            var texCoordBR = UnitX;

            if ((effects & SpriteEffects.FlipVertically) != 0)
            {
                var temp = texCoordBR.Y;
				texCoordBR.Y = texCoordTL.Y;
				texCoordTL.Y = temp;
            }
            if ((effects & SpriteEffects.FlipHorizontally) != 0)
            {
                var temp = texCoordBR.X;
				texCoordBR.X = texCoordTL.X;
				texCoordTL.X = temp;
            }

			var item = _batcher.CreateBatchItem();
			item.Texture = texture;

            item.SortKey = (float)SpriteSortMode.Texture;
            item.Set(position.X,
                     position.Y,
                     texture.Width,
                     texture.Height,
                     color,
                     texCoordBR,
                     texCoordTL,
                     layerDepth);

            FlushIfNeeded();
        }


		// Mark the end of a draw operation for Immediate SpriteSortMode.
		internal void FlushIfNeeded()
		{
			if (_sortMode == SpriteSortMode.Immediate)
			{
                _batcher.Camera = _camera;
				_batcher.DrawBatch(_sortMode);
			}
		}

        public void End()
        {
            if (!_beginCalled)
                throw new Exception.InvalidOperationException("Begin must be called before calling End.");

			_beginCalled = false;

            _batcher.Camera = _camera;
            _batcher.DrawBatch(_sortMode);
        }

        public void Dispose() 
        {
            _batcher.Dispose();
        }

        void CheckValid(Texture2D? texture)
        {
            if (texture == null)
                throw new Exception.ArgumentNullException("texture");
            if (!_beginCalled)
                throw new Exception.InvalidOperationException("Draw was called, but Begin has not yet been called. Begin must be called successfully before you can call Draw.");
        }
    }
}