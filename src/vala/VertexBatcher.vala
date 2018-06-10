using GL;
using System;
using Microsoft.Xna.Framework;

namespace Microsoft.Xna.Framework.Graphics 
{
    public class VertexBatcher : Object
    {
        /// <summary>
        /// Initialization size for the batch item list and queue.
        /// </summary>
        private const int InitialBatchSize = 256;
        /// <summary>
        /// The maximum number of batch items that can be processed per iteration
        /// </summary>
        private const int MaxBatchSize = short.MAX / 6; // 6 = 4 vertices unique and 2 shared, per quad
        /// <summary>
        /// Initialization size for the vertex array, in batch units.
        /// </summary>
		private const int InitialVertexArraySize = 256;

        /// <summary>
        /// The list of batch items to process.
        /// </summary>
	    private VertexBatchItem[] _batchItemList;
        /// <summary>
        /// Index pointer to the next available SpriteBatchItem in _batchItemList.
        /// </summary>
        private int _batchItemCount;

        /// <summary>
        /// The target graphics device.
        /// </summary>
        public GraphicsDevice device { get; construct; }

        /// <summary>
        /// Vertex index array. The values in this array never change.
        /// </summary>
        private short[] _index;

        private VertexPositionColorTexture[] _vertexArray;

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
            int neededCapacity = 6 * numBatchItems;
            if (_index != null && neededCapacity <= _index.length)
            {
                // Short circuit out of here because we have enough capacity.
                return;
            }
            short[] newIndex = new short[6 * numBatchItems];
            int start = 0;
            if (_index != null)
            {
                Memory.copy(newIndex, _index, _index.length);
                start = _index.length / 6;
            }
            short* indexFixedPtr = newIndex;
            {
                var indexPtr = indexFixedPtr + (start * 6);
                for (var i = start; i < numBatchItems; i++, indexPtr += 6)
                {
                    /*
                     *  TL    TR
                     *   0----1 0,1,2,3 = index offsets for vertex indices
                     *   |   /| TL,TR,BL,BR are vertex references in SpriteBatchItem.
                     *   |  / |
                     *   | /  |
                     *   |/   |
                     *   2----3
                     *  BL    BR
                     */
                    // Triangle 1
                    *(indexPtr + 0) = (short)(i * 4);
                    *(indexPtr + 1) = (short)(i * 4 + 1);
                    *(indexPtr + 2) = (short)(i * 4 + 2);
                    // Triangle 2
                    *(indexPtr + 3) = (short)(i * 4 + 1);
                    *(indexPtr + 4) = (short)(i * 4 + 3);
                    *(indexPtr + 5) = (short)(i * 4 + 2);
                }
            }
            _index = newIndex;

            _vertexArray = new VertexPositionColorTexture[4 * numBatchItems];
        }
        
        public void DrawBatch(SpriteSortMode sortMode)//, Effect effect)
		{
            // if (effect != null && effect.IsDisposed)
            //     throw new ObjectDisposedException("effect");

			// nothing to do
            if (_batchItemCount == 0)
				return;
			
			// sort the batch items
			// switch ( sortMode )
			// {
			// case SpriteSortMode.Texture :                
			// case SpriteSortMode.FrontToBack :
			// case SpriteSortMode.BackToFront :
            //     Array.Sort(_batchItemList, 0, _batchItemCount);
			// 	break;
			// }

            // Determine how many iterations through the drawing code we need to make
            int batchIndex = 0;
            int batchCount = _batchItemCount;

            
            _device._graphicsMetrics._spriteCount += batchCount;

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
                // Avoid the array checking overhead by using pointer indexing!
                VertexPositionTexture* vertexArrayFixedPtr = _vertexArray;
                var vertexArrayPtr = vertexArrayFixedPtr;

                // Draw the batches
                for (int i = 0; i < numBatchesToProcess; i++, batchIndex++, index += 4, vertexArrayPtr += 4)
                {
                    VertexBatchItem item = _batchItemList[batchIndex];
                    // if the texture changed, we need to flush and bind the new texture
                    var shouldFlush = !ReferenceEquals(item.Texture, tex);
                    if (shouldFlush)
                    {
                        FlushVertexArray(startIndex, index, tex);

                        tex = item.Texture;
                        startIndex = index = 0;
                        vertexArrayPtr = vertexArrayFixedPtr;
                        // _device.Textures[0] = tex;
                    }

                    // store the SpriteBatchItem data in our vertexArray
                    // *(vertexArrayPtr+0) = item.vertexTL;
                    // *(vertexArrayPtr+1) = item.vertexTR;
                    // *(vertexArrayPtr+2) = item.vertexBL;
                    // *(vertexArrayPtr+3) = item.vertexBR;

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

        private void FlushVertexArray(int start, int end, Texture? texture)
        {
            if (start == end)
                return;

            var vertexCount = end - start;

            // // If the effect is not null, then apply each pass and render the geometry
            // if (effect != null)
            // {
            //     var passes = effect.CurrentTechnique.Passes;
            //     foreach (var pass in passes)
            //     {
            //         pass.Apply();

            //         // Whatever happens in pass.Apply, make sure the texture being drawn
            //         // ends up in Textures[0].
            //         _device.Textures[0] = texture;

            //         _device.DrawUserIndexedPrimitives(
            //             PrimitiveType.TriangleList,
            //             _vertexArray,
            //             0,
            //             vertexCount,
            //             _index,
            //             0,
            //             (vertexCount / 4) * 2,
            //             VertexPositionTexture.VertexDeclaration);
            //     }
            // }
            // else
            // {
                // If no custom effect is defined, then simply render.
                _device.DrawUserIndexedPrimitives(
                    PrimitiveType.TriangleList,
                    _vertexArray,
                    0,
                    vertexCount,
                    _index,
                    0,
                    (vertexCount / 4) * 2,
                    null);
            }
        // }
        
    }
}