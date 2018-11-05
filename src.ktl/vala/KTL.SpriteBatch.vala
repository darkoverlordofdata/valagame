namespace Microsoft.Xna.Framework.KTL
{
    //  https://gitlab.com/Partanen/KTL_SpriteBatch

    using System;
    using System.Collections.Generic;
    using ValaGame.OpenGL;
    using Microsoft.Xna.Framework.Graphics;


    public class SpriteBatchItem : Object
    {
        public uint texture;
        public float position[2];
        public float dimensions[2];
        public float clip[4];
        public float color[4];
        public float rotation;
        public float rot_origin[2];
        public float layer;

        internal void SetItemDefaultDimensions(Rectangle clip)
        {
            dimensions[0] = (float)clip.Width;
            dimensions[1] = (float)clip.Height;
        }

        internal void SetItemScaledDimensions(Rectangle clip, Vector2 scale)
        {
            dimensions[0] = (float)clip.Width *scale.X;
            dimensions[1] = (float)clip.Height *scale.Y;
        }

        internal void SetItemDefaultColor()
        {
            color[0] = 1.0f;
            color[1] = 1.0f;
            color[2] = 1.0f;
            color[3] = 1.0f;
        }

        internal void SetItemModColor(Color rgba)
        {
            color[0] = (float)rgba.R;
            color[1] = (float)rgba.G;
            color[2] = (float)rgba.B;
            color[3] = (float)rgba.A;
        }

        internal void SetItemDefaultClip(Texture2D texture, Rectangle rect)
        {
            clip[0] = (float)rect.X / (float)texture.width;
            clip[1] = (float)rect.Y / (float)texture.height;
            clip[2] = ((float)rect.X + (float)rect.Width) / (float)texture.width;
            clip[3] = ((float)rect.Y + (float)rect.Height) / (float)texture.height;
        }

        internal void SetItemFlippedClip(Flip flip, Texture2D texture, Rectangle rect)
        {
            switch (flip)
            {
            case Flip.FLIP_NONE:
                clip[0] = (float)rect.X / (float)texture.width;
                clip[1] = (float)rect.Y / (float)texture.height;
                clip[2] = (float)(rect.X + rect.Width) / (float)texture.width;
                clip[3] = (float)(rect.Y + rect.Height) / (float)texture.height;
                break;
            case Flip.FLIP_HORIZONTAL:
                clip[0] = (float)(rect.X + rect.Width) / (float)texture.width;
                clip[1] = (float)rect.Y / (float)texture.height;
                clip[2] = (float)rect.X / (float)texture.width;
                clip[3] = (float)(rect.Y + rect.Height) / (float)texture.height;
                break;
            case Flip.FLIP_VERTICAL:
                clip[0] = (float)rect.X / (float)texture.width;
                clip[1] = (float)(rect.Y + rect.Height) / (float)texture.height;
                clip[2] = (float)(rect.X + rect.Width) / (float)texture.width;
                clip[3] = (float)rect.Y / (float)texture.height;
                break;
            case Flip.FLIP_BOTH:
                clip[0] = (float)rect.X / (float)texture.width;
                clip[1] = (float)rect.Y / (float)texture.height;
                clip[2] = (float)(rect.X + rect.Width) / (float)texture.width;
                clip[3] = (float)(rect.Y + rect.Height) / (float)texture.height;
                break;
            }
        }
        public int CompareTo(SpriteBatchItem other)
        {
            return layer.CompareTo(other.layer);
        }

    }

    /*  Shorthand functions for loading new shaders.
    *  Simply pass in the GLSL code */

    internal uint CreateShader(ShaderType shader_type, string shader_code)
    {
        uint shader_ID = GL.CreateShader(shader_type);
        string[] source = { shader_code };

        GL.ShaderSource(shader_ID, 1, source, null);
        GL.CompileShader(shader_ID);

        return shader_ID;
    }
    public uint CreateShaderProgram(uint vertex_shader, uint fragment_shader)
    {
        uint shader = GL.CreateProgram();

        GL.AttachShader(shader, vertex_shader);
        GL.AttachShader(shader, fragment_shader);
        GL.LinkProgram(shader);
        GL.DetachShader(shader, vertex_shader);
        GL.DetachShader(shader, fragment_shader);

        return shader;
    }
    public void DeleteShader(uint shader)
    {
        GL.DeleteShader(shader);
    }
    public void DeleteShaderProgram(uint shader_program)
    {
        GL.DeleteProgram(shader_program);
    }

    public enum Flip
    {
        FLIP_NONE,
        FLIP_HORIZONTAL,
        FLIP_VERTICAL,
        FLIP_BOTH
    }


    public class SpriteBatch : Object
    {
        public const string[] FragmentShader = 
        {
            "in vec2 tex_pos;",
            "in vec4 tint;",
            "out vec4 color;",
            "uniform sampler2D tex;",
            "uniform float global_alpha;",
            "void main(void)",
            "{",
            "   color = vec4(tint.x, tint.y, tint.z, global_alpha * tint.w) * texture(tex, tex_pos);",
            "}"
        };
        public const string[] VertexShader = 
        {
            "layout (location = 0) in vec4 position;",
            "layout (location = 1) in vec4 in_tint;",
            "out vec2 tex_pos;",
            "out vec4 tint;",
            "uniform mat4 projection;",
            "void main(void)",
            "{",
            "   gl_Position = projection * vec4(position.x, position.y, 0.0f, 1.0f);",
            "   tex_pos = vec2(position.z, position.w);",
            "   tint = in_tint;",
            "}"
        };
        /*  The maximum amount of sprite data to be sent to
        *  the GPU at one time. */
        const int KTL_BATCH_SIZE = 2048;
        const int KTL_DEFAULT_SHADER_PROGRAM = 0;
        bool is_initialized;
        bool batching_started;

        int sprite_count;

        uint shader;
        uint override_shader;
        uint vao;
        uint vbo;
        uint ebo;

        float scale_x;
        float scale_y;
        float alpha;
        bool alpha_changed;
        bool sorting;
        bool override_viewport;
        int or_viewport[4];

        GenericArray<SpriteBatchItem> sprite_buffer;
        float[] vertex_buffer = new float[KTL_BATCH_SIZE * 32];

        public SpriteBatch()
        {
            is_initialized     = false;
            batching_started   = false;
            sprite_count = 0;

        }
        ~SpriteBatch()
        {

        }

        /* Initialize the batch for use. initial_size is the
         * starting batch size. If more sprites are queued,
         * the batch is automatically enlarged. */
        public bool Create(uint initial_size = 256)
        {
            if (is_initialized) return is_initialized;

            alpha_changed = true;
            batching_started = false;

            // sprite_buffer = new ArrayList<SpriteBatchItem?>();
            sprite_buffer = new GenericArray<SpriteBatchItem>();
            string vertex_code = "#version 300 es\n"+string.joinv("\n", VertexShader);
            string fragment_code = "#version 300 es\n"+string.joinv("\n", FragmentShader);

            uint vertex_shader    = CreateShader(ShaderType.VertexShader, vertex_code);
            uint fragment_shader  = CreateShader(ShaderType.FragmentShader, fragment_code);

            shader = CreateShaderProgram(vertex_shader, fragment_shader);

            DeleteShader(vertex_shader);
            DeleteShader(fragment_shader);

            GL.UseProgram(shader);

            GL.GenVertexArrays(1, &vao);
            GL.GenBuffers(1, &vbo);
            GL.GenBuffers(1, &ebo);

            GL.BindVertexArray(vao);

            GL.BindBuffer(BufferTarget.ArrayBuffer, vbo);

            GL.VertexAttribPointer(0, 4, DataType.Float, false, (int)(8 * sizeof(float)), (void*)0);
            GL.EnableVertexAttribArray(0);

            GL.VertexAttribPointer(1, 4, DataType.Float, false, (int)(8 * sizeof(float)), (void*)(4 * sizeof(float)));
            GL.EnableVertexAttribArray(1);

            GL.BufferData(BufferTarget.ArrayBuffer, KTL_BATCH_SIZE * (32 * sizeof(float)), vertex_buffer, BufferUsageHint.DynamicDraw); //GL_DYNAMIC_DRAW);

            //Element array buffer
            int indices[6] = {0, 1, 2, 2, 3, 1};
            int *indice_array = new int[KTL_BATCH_SIZE * 6];

            for (int i = 0; i < KTL_BATCH_SIZE; ++i)
                for (int j = 0; j < 6; ++j)
                    indice_array[i * 6 + j] = indices[j] + i * 4;

            GL.BindBuffer(BufferTarget.ElementArrayBuffer, ebo);
            GL.BufferData(BufferTarget.ElementArrayBuffer, KTL_BATCH_SIZE * 6 * sizeof(int), indice_array, BufferUsageHint.DynamicDraw); //GL_DYNAMIC_DRAW);

            indice_array = new int[0];

            GL.BindBuffer(BufferTarget.ArrayBuffer, 0);

            GL.BindVertexArray(0);

            is_initialized = true;
            return is_initialized;
        }

        public void Begin()
        {
            if (!is_initialized || batching_started) return;

            sprite_count = 0;
            batching_started = true;
            override_shader = 0;
            override_viewport = false;
            sorting = true;

            scale_x = 1.0f;
            scale_y = 1.0f;

            if (alpha != 1.0f) alpha_changed = true;
            alpha = 1.0f;
        }

        public void BeginMod(uint or_shader, // Pass in 0 to use the default shader
                   float global_alpha,           // Multiply all queued sprites' alpha by this value
                   Vector2 scale,
                   bool sort = true,      // If sorting is enabled, sprites with a lower layer are drawn first
                   Rectangle? viewp = null) // Projection viewport - if null, will use OpenGL's own 
        {
            if (!is_initialized || batching_started) return;

            sprite_count = 0;
            batching_started = true;
            override_shader = or_shader;
            sorting = sort;

            scale_x = (float)scale.X;
            scale_y = (float)scale.Y;
            if (alpha != global_alpha) alpha_changed = true;
            alpha = global_alpha;

            if (viewp != null)
            {
                or_viewport[0] = viewp.X;
                or_viewport[1] = viewp.Y;
                or_viewport[2] = viewp.Width;
                or_viewport[3] = viewp.Height;
                override_viewport = true;
            }
            else
                override_viewport = false;
        }

        internal SpriteBatchItem CreateItem(uint texture, int x, int y, int layer)
        {
            if (sprite_count+1 > sprite_buffer.length)
                sprite_buffer.add(new SpriteBatchItem());
            SpriteBatchItem item = sprite_buffer[sprite_count];
            item.texture = texture;
            item.position[0] = (float)x;
            item.position[1] = (float)y;
            item.layer = layer;
            return item;
        }

        internal void Draw(Texture2D texture,
                  Rectangle clip,
                  int x, int y, int layer)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemDefaultColor();
            item.rotation = 0.0f;
            ++sprite_count;

        }

        internal void DrawScaled(Texture2D texture,
                        Rectangle clip,
                        int x, int y, int layer,
                        Vector2 scale)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemScaledDimensions(clip, scale);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemDefaultColor();
            item.rotation = 0.0f;
            ++sprite_count;
        }

        internal void DrawFlipped(Texture2D texture,
                         Rectangle clip,
                         int x, int y, int layer,
                         Flip flip)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemFlippedClip(flip, texture, clip);
            item.SetItemDefaultColor();
            item.rotation = 0.0f;
            ++sprite_count;
        }

        /*  Colored drawing multiplies the texture's colors by the
         *  input color. This can be used to apply alpha alone,
         *  by passing in {1.0f, 1.0f, 1.0f, desired_alpha} */
        internal void DrawTinted(Texture2D texture,
                        Rectangle clip,
                        int x, int y, int layer,
                        Color color)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemModColor(color);
            item.rotation = 0.0f;
            ++sprite_count;
        }

        internal void DrawRotated(Texture2D texture,
                         Rectangle clip,
                         int x, int y, int layer,
                         float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemDefaultColor();
            item.rotation = rot;
            item.rot_origin[0] = (float)x + (float)clip.Width/2.0f;
            item.rot_origin[1] = (float)y + (float)clip.Height/2.0f;
            ++sprite_count;
        }


        internal void DrawScaledFlipped(Texture2D texture,
                               Rectangle clip,
                               int x, int y, int layer,
                               Vector2 scale,
                               Flip flip)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemScaledDimensions(clip, scale);
            item.SetItemFlippedClip(flip, texture, clip);
            item.SetItemDefaultColor();
            item.rotation = 0.0f;
            ++sprite_count;
        }

        internal void DrawScaledRotated(Texture2D texture,
                               Rectangle clip,
                               int x, int y, int layer,
                               Vector2 scale,
                               float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemScaledDimensions(clip, scale);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemDefaultColor();
            item.rotation = rot;
            item.rot_origin[0] = (float)x + (float)clip.Width/2.0f;
            item.rot_origin[1] = (float)y + (float)clip.Height/2.0f;
            ++sprite_count;
        }

        internal void DrawScaledTinted(Texture2D texture,
                              Rectangle clip,
                              int x, int y, int layer,
                              Vector2 scale,
                              Color color)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemScaledDimensions(clip, scale);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemModColor(color);
            item.rotation = 0.0f;
            ++sprite_count;
        }

        internal void DrawScaledTintedRotated(Texture2D texture,
                                     Rectangle clip,
                                     int x, int y, int layer,
                                     Vector2 scale,
                                     Color color,
                                     float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemScaledDimensions(clip, scale);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemModColor(color);
            item.rotation = rot;
            item.rot_origin[0] = (float)x + (float)clip.Width/2.0f;
            item.rot_origin[1] = (float)y + (float)clip.Height/2.0f;
            ++sprite_count;
        }

        internal void DrawScaledFlippedTinted(Texture2D texture,
                                     Rectangle clip,
                                     int x, int y, int layer,
                                     Vector2 scale,
                                     Flip flip,
                                     Color color)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemScaledDimensions(clip, scale);
            item.SetItemFlippedClip(flip, texture, clip);
            item.SetItemModColor(color);
            item.rotation = 0.0f;
            ++sprite_count;
        }

        internal void DrawFlippedRotated(Texture2D texture,
                                Rectangle clip,
                                int x, int y, int layer,
                                Flip flip,
                                float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemFlippedClip(flip, texture, clip);
            item.SetItemDefaultColor();
            item.rotation = rot;
            item.rot_origin[0] = (float)x + (float)clip.Width/2.0f;
            item.rot_origin[1] = (float)y + (float)clip.Height/2.0f;
            ++sprite_count;
        }


        internal void DrawFlippedTinted(Texture2D texture,
                               Rectangle clip,
                               int x, int y, int layer,
                               Flip flip,
                               Color color)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemFlippedClip(flip, texture, clip);
            item.SetItemModColor(color);
            item.rotation = 0.0f;
            ++sprite_count;
        }


        internal void DrawTintedRotated(Texture2D texture,
                               Rectangle clip,
                               int x, int y, int layer,
                               Color color,
                               float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemDefaultClip(texture, clip);
            item.SetItemModColor(color);
            item.rotation = rot;
            item.rot_origin[0] = (float)x + (float)clip.Width/2.0f;
            item.rot_origin[1] = (float)y + (float)clip.Height/2.0f;
            ++sprite_count;
        }

        internal void DrawFlippedTintedRotated(Texture2D texture,
                                      Rectangle clip,
                                      int x, int y, int layer,
                                      Flip flip,
                                      Color color,
                                      float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.SetItemDefaultDimensions(clip);
            item.SetItemFlippedClip(flip, texture, clip);
            item.SetItemModColor(color);
            item.rotation = rot;
            item.rot_origin[0] = (float)x + (float)clip.Width/2.0f;
            item.rot_origin[1] = (float)y + (float)clip.Height/2.0f;
            ++sprite_count;
        }

        internal void DrawScaledFlippedTintedRotated(Texture2D texture,
                                            Rectangle clip,
                                            int x, int y, int layer,
                                            Vector2 scale,
                                            Flip flip,
                                            Color color,
                                            float rot)
        {
            if (!batching_started) return;
            SpriteBatchItem item = CreateItem(texture.Handle, x, y, layer);
            item.rotation = 0.0f;
            ++sprite_count;
        }

        void RotatePixel(
                    ref float x, 
                    ref float y,
                    float orig_x, 
                    float orig_y,
                    float angle)
        {
            float trans_x = x - orig_x;
            float trans_y = y - orig_y;

            float rot_x = trans_x * Math.cosf(angle) - trans_y * Math.sinf(angle);
            float rot_y = trans_x * Math.sinf(angle) + trans_y * Math.cosf(angle);

            x = rot_x + orig_x;
            y = rot_y + orig_y;
        }


        public void End()
        {
            const int GL_VIEWPORT= 0x0BA2; // decimal value: 2978

            if (!is_initialized
            || !batching_started
            || sprite_count < 1)
                return;

            if (sorting)
                sprite_buffer.sort_with_data((a, b) => a.CompareTo(b));
            //     std::sort(sprite_buffer.begin(), sprite_buffer.begin()+sprite_count, SortFunc);

            //Calculate the projection matrix by viewport dimensions
            int viewport[4];
            if (!override_viewport)
                GL.GetIntegerv(GL_VIEWPORT, viewport);
            else
            {
                viewport[0] = or_viewport[0];
                viewport[1] = or_viewport[1];
                viewport[2] = or_viewport[2];
                viewport[3] = or_viewport[3];
            }

            float projection[16] =
            {
                2.0f / (float)(viewport[2] - viewport[0]),
                0.0f,
                0.0f,
                0.0f,

                0.0f,
                2.0f / (float)(viewport[1] - viewport[3]),
                0.0f,
                0.0f,

                0.0f,
                0.0f,
                -1.0f,
                0.0f,

                - (float)(viewport[2] + viewport[0]) / (float)(viewport[2] - viewport[0]),
                - (float)(viewport[1] + viewport[3]) / (float)(viewport[1] - viewport[3]),
                0.0f,
                1.0f
            };

            uint program = (override_shader == 0) ? shader : override_shader;
            GL.UseProgram(program);

            GL.UniformMatrix4fv(GL.GetUniformLocation(program, "projection"), 1, false, &projection[0]);

            if (alpha_changed)
            {
                GL.Uniform1f(GL.GetUniformLocation(program, "global_alpha"), alpha);
                alpha_changed = false;
            }

            GL.BindVertexArray(vao);

            GL.BindBuffer(BufferTarget.ArrayBuffer, vbo);
            GL.BindBuffer(BufferTarget.ElementArrayBuffer, ebo);

            // How many batches to process
            int num_batches = sprite_count / KTL_BATCH_SIZE;

            for (int batch_num = 0; batch_num < num_batches + 1; ++batch_num)
            {
                int num_sprites = sprite_count - batch_num * KTL_BATCH_SIZE;
                if (num_sprites > KTL_BATCH_SIZE) num_sprites = KTL_BATCH_SIZE;

                for (int i = batch_num * KTL_BATCH_SIZE; i < batch_num * KTL_BATCH_SIZE + num_sprites; ++i)
                {
                    SpriteBatchItem item = sprite_buffer[i];

                    int fixed_i = (i - (i / KTL_BATCH_SIZE * KTL_BATCH_SIZE)) * 32;

                    /* Top left */
                    vertex_buffer[fixed_i     ] = scale_x * item.position[0];
                    vertex_buffer[fixed_i +  1] = scale_y * item.position[1];
                    vertex_buffer[fixed_i +  2] = item.clip[0];
                    vertex_buffer[fixed_i +  3] = item.clip[1];
                    vertex_buffer[fixed_i +  4] = item.color[0];
                    vertex_buffer[fixed_i +  5] = item.color[1];
                    vertex_buffer[fixed_i +  6] = item.color[2];
                    vertex_buffer[fixed_i +  7] = item.color[3];
                    /* Top right */
                    vertex_buffer[fixed_i +  8] = scale_x * (item.position[0] + item.dimensions[0]);
                    vertex_buffer[fixed_i +  9] = scale_y * item.position[1];
                    vertex_buffer[fixed_i + 10] = item.clip[2];
                    vertex_buffer[fixed_i + 11] = item.clip[1];
                    vertex_buffer[fixed_i + 12] = item.color[0];
                    vertex_buffer[fixed_i + 13] = item.color[1];
                    vertex_buffer[fixed_i + 14] = item.color[2];
                    vertex_buffer[fixed_i + 15] = item.color[3];
                    /* Bottom left */
                    vertex_buffer[fixed_i + 16] = scale_x * item.position[0];
                    vertex_buffer[fixed_i + 17] = scale_y * (item.position[1]  + item.dimensions[1]);
                    vertex_buffer[fixed_i + 18] = item.clip[0];
                    vertex_buffer[fixed_i + 19] = item.clip[3];
                    vertex_buffer[fixed_i + 20] = item.color[0];
                    vertex_buffer[fixed_i + 21] = item.color[1];
                    vertex_buffer[fixed_i + 22] = item.color[2];
                    vertex_buffer[fixed_i + 23] = item.color[3];
                    /* Bottom right */
                    vertex_buffer[fixed_i + 24] = scale_x * (item.position[0] + item.dimensions[0]);
                    vertex_buffer[fixed_i + 25] = scale_y * (item.position[1] + item.dimensions[1]);
                    vertex_buffer[fixed_i + 26] = item.clip[2];
                    vertex_buffer[fixed_i + 27] = item.clip[3];
                    vertex_buffer[fixed_i + 28] = item.color[0];
                    vertex_buffer[fixed_i + 29] = item.color[1];
                    vertex_buffer[fixed_i + 30] = item.color[2];
                    vertex_buffer[fixed_i + 31] = item.color[3];

                    //Rotate if necessary
                    if (item.rotation != 0.0f)
                    {
                        RotatePixel(ref vertex_buffer[fixed_i     ], 
                                    ref vertex_buffer[fixed_i +  1],
                                        item.rot_origin[0], 
                                        item.rot_origin[1], 
                                        item.rotation);
                        RotatePixel(ref vertex_buffer[fixed_i +  8], 
                                    ref vertex_buffer[fixed_i +  9],
                                        item.rot_origin[0], 
                                        item.rot_origin[1], 
                                        item.rotation);
                        RotatePixel(ref vertex_buffer[fixed_i + 16], 
                                    ref vertex_buffer[fixed_i + 17],
                                        item.rot_origin[0], 
                                        item.rot_origin[1], 
                                        item.rotation);
                        RotatePixel(ref vertex_buffer[fixed_i + 24], 
                                    ref vertex_buffer[fixed_i + 25],
                                        item.rot_origin[0], 
                                        item.rot_origin[1], 
                                        item.rotation);
                    }
                }

                int size_multip = sprite_count - batch_num * KTL_BATCH_SIZE;
                if (size_multip > KTL_BATCH_SIZE) size_multip = KTL_BATCH_SIZE;

                GL.BufferSubData(BufferTarget.ArrayBuffer,                        // Target
                                0,                                      // Offset
                                size_multip * (32 * sizeof(float)),   // Size
                                &vertex_buffer[0]);                     // Data

                uint last_texture = sprite_buffer[batch_num * KTL_BATCH_SIZE].texture;
                int offset = 0;

                SpriteBatchItem sprite;
                for (int i = 0; i < num_sprites; ++i)
                {
                    sprite = sprite_buffer[batch_num * KTL_BATCH_SIZE + i];

                    if (sprite.texture != last_texture)
                    {
                        GL.BindTexture(TextureTarget.Texture2D, last_texture);
                        GL.DrawElements(PrimitiveType.Triangles,
                                    (i - offset) * 6,
                                    DataType.UnsignedInt,
                                    (void *)(offset * 6 * sizeof(uint)));
                        offset = i;
                        last_texture = sprite.texture;
                    }
                }

                GL.BindTexture(TextureTarget.Texture2D, last_texture);
                GL.DrawElements(PrimitiveType.Triangles,
                            (num_sprites - offset) * 6,
                            DataType.UnsignedInt,
                            (void*)(offset * 6 * sizeof(uint)));
            }
            GL.BindTexture(TextureTarget.Texture2D, 0);
            GL.BindBuffer(BufferTarget.ArrayBuffer, 0);

            GL.BindVertexArray(0);
            GL.UseProgram(0);
            batching_started = false;

        }

        /* Resize the sprite buffer, calling std::vector.clear(),
         * hence causing a reallocation. Fails if called between
         * begin() and end(). Returns the new size.*/
        public int ResizeBuffer(uint new_size)
        {
            if (is_initialized && !batching_started)
            {
                sprite_buffer.remove_range(0, sprite_buffer.length);
            }

            return sprite_buffer.length;
        }

        public int GetBufferSize()
        {
            return sprite_buffer.length;
        }

        /* Free any resources used by the batch from the GPU and memory. */
        public void Dispose()
        {
            if (!is_initialized) return;

            GL.DeleteBuffers(1, &vbo);
            GL.DeleteBuffers(1, &ebo);
            GL.DeleteVertexArrays(1, &vao);
            GL.DeleteProgram(shader);

            sprite_buffer.remove_range(0, sprite_buffer.length);
            is_initialized = false;
            batching_started = false;
        }



    }

}