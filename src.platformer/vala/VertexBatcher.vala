using System;
using Microsoft.Xna.Framework;
using ValaGame.OpenGL;

namespace Microsoft.Xna.Framework.Graphics 
{
    public class VertexBatcher : Object
    {
        /// <summary>
        /// Size of float array chunk per Texture Coordinatre batch item.
        /// </summary>
        private const int TexCoordSize = 6 * 12;
        /// <summary>
        /// Size of float array chunk per Position batch item.
        /// </summary>
        private const int PositionSize = 6 * 18;
        /// <summary>
        /// Initialization size for the batch item list and queue.
        /// </summary>
        private const int InitialBatchSize = 8; // 256;
        /// <summary>
        /// The maximum number of batch items that can be processed per iteration
        /// </summary>
        private const int MaxBatchSize = short.MAX / 6; // 6 = 4 vertices unique and 2 shared, per quad
        /// <summary>
        /// Initialization size for the vertex array, in batch units.
        /// </summary>
		private const int InitialVertexArraySize = 8; // 256;

        /// <summary>
        /// The list of batch items to process.
        /// </summary>
	    private VertexBatchItem[] _batchItemList;
        /// <summary>
        /// Index pointer to the next available SpriteBatchItem in _batchItemList.
        /// </summary>
        private int _batchItemCount;

        /// <summary>
        /// Current camera locus.
        /// </summary>
        public Vector2 Camera = Vector2.Zero; 
        /// <summary>
        /// The target graphics device.
        /// </summary>
        public GraphicsDevice device { get; construct; }

        /// <summary>
        /// Vertex texture coordinates
        /// </summary>
        private int _indexTexCoords = 0;
        private uint _texcoordsVbo; // S.B in GraphicsDevice
        private float[] _vertexTexCoords = new float[0];
        /// <summary>
        /// Vertex texture positions
        /// </summary>
        private int _indexPositions = 0;
        private uint _positionsVbo; // S.B in GraphicsDevice
        private float[] _vertexPositions = new float[0];

        private VertexBuffer _positions = new VertexBuffer();
        private VertexBuffer _texCoords = new VertexBuffer();


		public VertexBatcher (GraphicsDevice device)
		{
            GLib.Object(device: device);

			_batchItemList = new VertexBatchItem[InitialBatchSize];
            _batchItemCount = 0;

            for (int i = 0; i < InitialBatchSize; i++)
                _batchItemList[i] = new VertexBatchItem();

            EnsureArrayCapacity(InitialBatchSize);
		}
        

        /// <summary>
        /// Reuse a previously allocated SpriteBatchItem from the item pool. 
        /// if there is none available grow the pool and initialize new items.
        /// </summary>
        /// <returns></returns>
        public VertexBatchItem CreateBatchItem()
        {
            if (_batchItemCount >= _batchItemList.length)
            {
                var oldSize = _batchItemList.length;
                var newSize = oldSize + oldSize/2; // grow by x1.5
                newSize = (newSize + 63) & (~63); // grow in chunks of 64.
                _batchItemList.resize(newSize);
                for(int i=oldSize; i<newSize; i++)
                    _batchItemList[i] = new VertexBatchItem();

                EnsureArrayCapacity(int.min(newSize, MaxBatchSize));
            }
            var item = _batchItemList[_batchItemCount++];
            return item;
        }
        
        /// <summary>
        /// Resize and recreate the missing indices for the index and vertex position color buffers.
        /// </summary>
        /// <param name="numBatchItems"></param>
        private void EnsureArrayCapacity(int numBatchItems)
        {
            int neededCapacity = TexCoordSize * numBatchItems;
            if (neededCapacity <= _vertexTexCoords.length)
            {
                // Short circuit out of here because we have enough capacity.
                return;
            }

            _vertexTexCoords.resize(numBatchItems * TexCoordSize);
            _vertexPositions.resize(numBatchItems * PositionSize);
            
        }
        
        public void DrawBatch(SpriteSortMode sortMode)
        {
			// nothing to do
            if (_batchItemCount == 0)
				return;
			
            // Determine how many iterations through the drawing code we need to make
            int batchIndex = 0;
            int batchCount = _batchItemCount;
            
            // Why??
            // _device._graphicsMetrics._spriteCount += batchCount;

            // Iterate through the batches, doing short.MaxValue sets of vertices only.
            while(batchCount > 0)
            {
                // setup the vertexArray array
                var startIndex = 0;
                var index = 0;
                Texture2D tex = null;

                int numBatchesToProcess = batchCount;
                if (numBatchesToProcess > MaxBatchSize)
                {
                    numBatchesToProcess = MaxBatchSize;
                }

                // Draw the batches
                for (int i = 0; i < numBatchesToProcess; i++, batchIndex++, index+=6)
                {
                    VertexBatchItem item = _batchItemList[batchIndex];
                    // if the texture changed, we need to flush and bind the new texture
                    var shouldFlush = !Object.ReferenceEquals(item.Texture, tex);
                    if (shouldFlush)
                    {
                        FlushVertexArray(startIndex, index, tex);

                        tex = item.Texture;
                        startIndex = index = 0;
                    }

                    CopyItemToArray(item);

                    // Release the texture.
                    item.Texture = null;
                }
                // flush the remaining vertexArray data

                FlushVertexArray(startIndex, index, tex);

                // Update our batch count to continue the process of culling down
                // large batches
                batchCount -= numBatchesToProcess;
            }
            // return items to the pool.  
            _batchItemCount = 0;
		}

        private void CopyItemToArray(VertexBatchItem item)
        {
            // print("_vertexPositions = %d, _indexPositions = %d\n", _vertexPositions.length, _indexPositions);
            _vertexPositions[_indexPositions++] = item.Vertex1TR.Position.X;
            _vertexPositions[_indexPositions++] = item.Vertex1TR.Position.Y;
            _vertexPositions[_indexPositions++] = 0;
            _vertexPositions[_indexPositions++] = item.Vertex1TL.Position.X;
            _vertexPositions[_indexPositions++] = item.Vertex1TL.Position.Y;
            _vertexPositions[_indexPositions++] = 0;
            _vertexPositions[_indexPositions++] = item.Vertex1BL.Position.X;
            _vertexPositions[_indexPositions++] = item.Vertex1BL.Position.Y;
            _vertexPositions[_indexPositions++] = 0;

            _vertexTexCoords[_indexTexCoords++] = item.Vertex1TR.TextureCoordinate.X; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex1TR.TextureCoordinate.Y; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex1TL.TextureCoordinate.X; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex1TL.TextureCoordinate.Y; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex1BL.TextureCoordinate.X; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex1BL.TextureCoordinate.Y; 


            _vertexPositions[_indexPositions++] = item.Vertex2TR.Position.X;
            _vertexPositions[_indexPositions++] = item.Vertex2TR.Position.Y;
            _vertexPositions[_indexPositions++] = 0;
            _vertexPositions[_indexPositions++] = item.Vertex2BR.Position.X;
            _vertexPositions[_indexPositions++] = item.Vertex2BR.Position.Y;
            _vertexPositions[_indexPositions++] = 0;
            _vertexPositions[_indexPositions++] = item.Vertex2BL.Position.X;
            _vertexPositions[_indexPositions++] = item.Vertex2BL.Position.Y;
            _vertexPositions[_indexPositions++] = 0;

            _vertexTexCoords[_indexTexCoords++] = item.Vertex2TR.TextureCoordinate.X; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex2TR.TextureCoordinate.Y; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex2BR.TextureCoordinate.X; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex2BR.TextureCoordinate.Y; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex2BL.TextureCoordinate.X; 
            _vertexTexCoords[_indexTexCoords++] = item.Vertex2BL.TextureCoordinate.Y; 
            
        }

        private void FlushVertexArray(int start, int end, Texture2D? texture)
        {
            if (start == end)
            {
                return;
            }

            var vertexCount = end - start;

            DrawUserIndexedPrimitives(texture);
            // // If no custom effect is defined, then simply render.
            // _device.DrawUserIndexedPrimitives(
            //     PrimitiveType.TriangleList,
            //     _vertexArray,
            //     0,
            //     vertexCount,
            //     _index,
            //     0,
            //     (vertexCount / 4) * 2,
            //     null);
                
            // Memory.set(_vertexTexCoords, 0, _vertexTexCoords.length*sizeof(float));
            // Memory.set(_vertexPositions, 0, _vertexPositions.length*sizeof(float));
            Memory.set(_vertexTexCoords, 0, _indexTexCoords*sizeof(float));
            Memory.set(_vertexPositions, 0, _indexPositions*sizeof(float));
            _indexTexCoords = 0;
            _indexPositions = 0;
        }

        private void DrawUserIndexedPrimitives1(Texture2D? texture)
        {
            // ApplyState(true);
            if (_positionsVbo == 0)
            {
                GL.GenBuffers(1, &_positionsVbo);
                GraphicsExtensions.CheckGLError();
                GL.GenBuffers(1, &_texcoordsVbo);
                GraphicsExtensions.CheckGLError();
            }
            
            GL.BindBuffer(BufferTarget.ArrayBuffer, _positionsVbo);
            GraphicsExtensions.CheckGLError();
            GL.BufferData(BufferTarget.ArrayBuffer, _vertexPositions.length*sizeof(float), _vertexPositions, BufferUsageHint.StaticDraw);
            GraphicsExtensions.CheckGLError();
            
            GL.BindBuffer(BufferTarget.ArrayBuffer, _texcoordsVbo);
            GraphicsExtensions.CheckGLError();
            GL.BufferData(BufferTarget.ArrayBuffer, _vertexTexCoords.length*sizeof(float), _vertexTexCoords, BufferUsageHint.StaticDraw);
            GraphicsExtensions.CheckGLError();
            
            // GL.BindBuffer(BufferTarget.ArrayBuffer, 0);

            GL.Use2DCamera(Camera);
            GL.BindTexture(TextureTarget.Texture2D, texture.Handle);
            GL.DrawUserArrays(_batchItemCount, _positionsVbo, _texcoordsVbo);
            // GL.PopState();
            
        }

        private void DrawUserIndexedPrimitives(Texture2D? texture)
        {
            // ApplyState(true);

            _positions.SetData<float?>(_vertexPositions, _vertexPositions.length);
            _texCoords.SetData<float?>(_vertexTexCoords, _vertexTexCoords.length);
            
            GL.Use2DCamera(Camera);
            GL.BindTexture(TextureTarget.Texture2D, texture.Handle);
            GL.DrawUserArrays(_batchItemCount, _positions.vbo, _texCoords.vbo);
            
        }

        public void Dispose() 
        {
            _positions.DisposeBuffer(_batchItemCount);
            _texCoords.DisposeBuffer(_batchItemCount);

            // GL.DeleteBuffers(_batchItemCount, &_positionsVbo);
            // GL.DeleteBuffers(_batchItemCount, &_texcoordsVbo);
        }
            
    }
    // public class VertexBuffer : Object
    // {
    //     internal uint vbo;
    //     /// <summary>
    //     /// If the VBO does not exist, create it.
    //     /// </summary>

    //     void GenerateIfRequired()
    //     {
    //         if (vbo == 0)
    //         {
    //             GL.GenBuffers(1, &vbo);
    //             GraphicsExtensions.CheckGLError();
    //          }
    //     }

    //     public void SetData<T>(T* data, int length)
    //     {
    //         GenerateIfRequired();
    //         GL.BindBuffer(BufferTarget.ArrayBuffer, vbo);
    //         GraphicsExtensions.CheckGLError();
    //         GL.BufferData(BufferTarget.ArrayBuffer, length*sizeof(T), (GL.void*)data, BufferUsageHint.StaticDraw);
    //         GraphicsExtensions.CheckGLError();
    //     }

    //     public void DisposeBuffer(int count) 
    //     {
    //         GL.DeleteBuffers(count, &vbo);
    //         // // GraphicsExtensions.CheckGLError();
    //     }
    // }
}