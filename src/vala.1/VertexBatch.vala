using GL;
using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace Microsoft.Xna.Framework.Graphics 
{
    //
    // Draw calls _batcher.CreateBatchItem() followed by item.Set
    //      this accumulates the items in the batch
    // End calls _batcher.DrawBatch() 
    //      this goes thru the batch and writes out the vertex data
    //
    // sets up for glDrawArrays. 
    // should use glDrawElements. I need a working example for 2D
    // until then - it's only an implementation detail.

    // array of struct of arrays:
    //  
    //      1 vertex per texture: (sprites)
    //
    //      | X1 | V1 | T1 | C1 |
    //      | X2 | V2 | T2 | C2 |
    //      | X3 | V3 | T3 | C3 |
    //      ...
    //      | X4 | Vn | Tn | Cn |
    //
    //  
    //      1+ vertex per texture: (tile maps)
    //          could also use for coin!
    //
    //      | X1 | V1 | V2 | T1 | T2 | C1 | C2 |...
    //      | X2 | V1 | V2 | T1 | T2 | C1 | C2 |...
    //      | X3 | V1 | V2 | T1 | T2 | C1 | C2 |...
    //
    //
    //

    public class VertexBatch : Object, IDisposable
    {
        Texture2D? Texture;
        int count = 0;
        Vector2 camera;

        // move to VertexBatcher
        int _countTexCoords = 0;
        int _countPositions = 0;
        GLuint _positionsVbo;
        GLuint _texcoordsVbo;
        float[] _vertexTexCoords;
        float[] _vertexPositions;
        // END: move to VertexBatcher

        bool _beginCalled = false;
        VertexBatcher _batcher;
		SpriteSortMode _sortMode;

		Vector2 _texCoordTL = new Vector2 (0,1);
		Vector2 _texCoordBR = new Vector2 (1,0);
        
        public VertexBatch(GraphicsDevice graphicsDevice)
        {
            _vertexTexCoords = new float[6*12];
            _vertexPositions = new float[6*18];
            GL.GenBuffers(1, &_positionsVbo);
            GL.GenBuffers(1, &_texcoordsVbo);
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
            this.camera = camera;
            Memory.set(_vertexTexCoords, 0, _vertexTexCoords.length*sizeof(float));
            Memory.set(_vertexPositions, 0, _vertexPositions.length*sizeof(float));
            _countTexCoords = 0;
            _countPositions = 0;
            count = 0;
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
            float layerDepth = 0f
            )
        {
            CheckValid(texture);
            Texture = texture;
            position = position ?? Vector2.Zero;
            destinationRectangle = destinationRectangle ?? new Quadrangle((int)position.X, (int)position.Y, texture.Width, texture.Height);
            sourceRectangle = sourceRectangle ?? new Quadrangle(0, 0, texture.Width, texture.Height);
            origin = origin ?? Vector2.Zero;
            scale = scale ?? Vector2.One;
            color = color ?? Color.White;

            if ((effects & SpriteEffects.FlipVertically) != 0)
            {
                var temp = _texCoordBR.Y;
				_texCoordBR.Y = _texCoordTL.Y;
				_texCoordTL.Y = temp;
            }
            if ((effects & SpriteEffects.FlipHorizontally) != 0)
            {
                var temp = _texCoordBR.X;
				_texCoordBR.X = _texCoordTL.X;
				_texCoordTL.X = temp;
            }

			var item = _batcher.CreateBatchItem();
			item.Texture = texture;

            item.SortKey = (float)SpriteSortMode.Texture;
            item.Set(position.X,
                     position.Y,
                     texture.Width,
                     texture.Height,
                     color,
                     _texCoordBR,
                     _texCoordTL,
                     layerDepth);

            FlushIfNeeded();

            // this needs to move to batcher:
            // Ensure capacity
            if (_vertexTexCoords.length <= count*12)
            {
                var inc = int.min(8, _vertexTexCoords.length/2);
                _vertexTexCoords.resize(_vertexTexCoords.length+(12*inc));
                _vertexPositions.resize(_vertexPositions.length+(18*inc));
            }
            count++;

            // Fixup for Flip
            float[,] Coord = 
            {
                { _texCoordBR.X, _texCoordTL.Y }, 
                { _texCoordTL.X, _texCoordTL.Y }, 
                { _texCoordTL.X, _texCoordBR.Y }, 

                { _texCoordBR.X, _texCoordTL.Y }, 
                { _texCoordBR.X, _texCoordBR.Y }, 
                { _texCoordTL.X, _texCoordBR.Y }
            };

            for (var i=0; i<6; i++) // Generate 6 pts. for 2 triangles
            {
                _vertexPositions[_countPositions++] = position.X + (Coord[i,0] * texture.Width);
                _vertexPositions[_countPositions++] = position.Y + (Coord[i,1] * texture.Height);
                _vertexPositions[_countPositions++] = 0;

                _vertexTexCoords[_countTexCoords++] = Coord[i,0]; 
                _vertexTexCoords[_countTexCoords++] = Coord[i,1]; 
            }
        }


		// Mark the end of a draw operation for Immediate SpriteSortMode.
		internal void FlushIfNeeded()
		{
			if (_sortMode == SpriteSortMode.Immediate)
			{
				_batcher.DrawBatch(_sortMode);
			}
		}

        public void End()
        {
            if (!_beginCalled)
                throw new Exception.InvalidOperationException("Begin must be called before calling End.");

			_beginCalled = false;

			// if (_sortMode != SpriteSortMode.Immediate)
			// 	Setup();
            
            // _batcher.DrawBatch(_sortMode, _effect);

            // Move to VertexBatcher.DrawBatch:

            GL.BindBuffer(BufferTarget.ArrayBuffer, _positionsVbo);
            GL.BufferData(BufferTarget.ArrayBuffer, _vertexPositions.length*sizeof(float), _vertexPositions, GL_STATIC_DRAW);
            
            GL.BindBuffer(BufferTarget.ArrayBuffer, _texcoordsVbo);
            GL.BufferData(BufferTarget.ArrayBuffer, _vertexTexCoords.length*sizeof(float), _vertexTexCoords, GL_STATIC_DRAW);
            
            GL.BindBuffer(BufferTarget.ArrayBuffer, 0);

            GL.PushState(camera);
            GL.BindTexture(TextureTarget.Texture2D, Texture.Handle);
            GL.DrawUserArrays(count, _positionsVbo, _texcoordsVbo);
            GL.PopState();
        }

        public void Dispose() 
        {
            GL.DeleteBuffers(count, &_positionsVbo);
            GL.DeleteBuffers(count, &_texcoordsVbo);
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