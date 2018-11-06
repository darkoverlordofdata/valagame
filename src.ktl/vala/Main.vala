//  https://gitlab.com/Partanen/KTL_SpriteBatch
#if (__EMSCRIPTEN__)
public int main(string[] args)
{
    var game = new Demo.Game();
    return 0;
}
#else
/**
 * Not sure why the linker wants a WinMain for desktop, but ok...
 */
public int WinMain(string[] args)
{
    var game = new Demo.Game();
    return 0;
}
#endif


namespace Demo
{
    using System;
    using ValaGame.OpenGL;
    using System.Collections.Generic;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Content;
    using Microsoft.Xna.Framework.Graphics;

    public class Game : Object
    {
        const int SCREEN_WIDTH = 800;
        const int SCREEN_HEIGHT = 600;
        const int VERSION = 300;
        const string PROFILE = "es";
        public static Game Instance;

        bool running;
        IntPtr window;
        IntPtr context;
        SpriteBatch spriteBatch;
        Texture2D spritesheet;
        Texture2D atlas;
        Rectangle tile_clip1 = new Rectangle(0, 0, 32, 32);
        Rectangle tile_clip2 = new Rectangle(0, 32, 32, 32);

        public Game()
        {
            Instance = this;
            Init();

            #if (__EMSCRIPTEN__)
            Emscripten.set_main_loop(() => Instance.Loop(), -1, 0);
            #else
            for (running = true; running;) Loop();
            Clean();
            #endif

        }

        public void Loop()
        {
            Update();
            Render();
        }

        public void Init()
        {
            Sdl.Init(Sdl.InitFlags.Video);
            #if (!__EMSCRIPTEN__)
            Sdl.GL.SetAttribute(Sdl.GL.Attribute.ContextMajorVersion, VERSION/10);
            Sdl.GL.SetAttribute(Sdl.GL.Attribute.ContextMajorVersion, (VERSION%100)/10);
            #endif
            Sdl.GL.SetAttribute(Sdl.GL.Attribute.DoubleBuffer, 1);

            print("Init1\n");
            window = Sdl.Window.Create("SDL2 example",
                                    -1,
                                    -1,
                                    SCREEN_WIDTH, SCREEN_HEIGHT,
                                    Sdl.Window.State.OpenGL);

            Sdl.GL.SetAttribute(Sdl.GL.Attribute.ShareWithCurrentContext, 1);
            context = Sdl.GL.CreateContext(window);
            Sdl.GL.SetSwapInterval(0);
            GL.LoadEntryPoints();

            GL.Enable(EnableCap.Blend);
            GL.BlendFunc(BlendingFactorSrc.SrcAlpha, BlendingFactorDest.OneMinusSrcAlpha);

            spritesheet = new Texture2D();
            spritesheet.SetData("assets/images/spritesheet.png");

            atlas = new Texture2D();
            atlas.SetData("assets/images/assets.png");

            spriteBatch = ResourceManager.CreateSpriteBatch(SCREEN_WIDTH, SCREEN_HEIGHT);
        }


        void Render()
        {
            GL.ClearColor(0.129f, 0.463f, 1.0f, 1.0f);
            GL.Clear(ClearBufferMask.ColorBufferBit);

            int mid_x = SCREEN_WIDTH/2  - 16;
            int mid_y = SCREEN_HEIGHT/2 - 16;

            int ticks = (int)Sdl.GetTicks();
            float floating = 2 * Math.sinf((float)(ticks * 1.75f * Math.PI / 5f));
            int y_add = (int)floating;
            var ONE = new Vector2(1f, 1f);

            // spriteBatch.Begin();
            // spriteBatch.Draw(atlas, { 2, 505, 512, 512 }, 0, 0, 0);
            // spriteBatch.DrawScaled(atlas, { 192, 331, 108, 172 }, 0, 0, 1, new Vector2(0.5f, 0.5f));
            // spriteBatch.End();


            spriteBatch.Begin();//0, 0.7f, ONE, false, null);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x,      mid_y - 100 + y_add, 0);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x-16,   mid_y - 100 + 8 - y_add, 1);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x+16,   mid_y - 100 + 8 + y_add, 1);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x-32,   mid_y - 100 + 16 - y_add, 2);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x,      mid_y - 100 + 16 + y_add, 2);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x+32,   mid_y - 100 + 16 - y_add, 2);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x-48,   mid_y - 100 + 24 + y_add, 3);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x-16,   mid_y - 100 + 24 - y_add, 3);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x+16,   mid_y - 100 + 24 + y_add, 3);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x+16,   mid_y - 100 + 24 - y_add, 3);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x+48,   mid_y - 100 + 24 + y_add, 3);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x-32,   mid_y - 100 + 32 - y_add, 4);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x,      mid_y - 100 + 32 + y_add, 4);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x+32,   mid_y - 100 + 32 - y_add, 4);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x-16,   mid_y - 100 + 40 + y_add, 5);
            spriteBatch.Draw(spritesheet, tile_clip2, mid_x+16,   mid_y - 100 + 40 - y_add, 5);
            spriteBatch.Draw(spritesheet, tile_clip1, mid_x,      mid_y - 100 + 48 + y_add, 6);
            spriteBatch.End();

            Sdl.GL.SwapWindow(window);

        }

        void Update()
        {
            Sdl.Event event;

            while(Sdl.PollEvent(out event) == 1)
            {
                switch (event.Type)
                {
                    case Sdl.EventType.Quit:
                        running = false;
                        break;
                    case Sdl.EventType.KeyDown:
                        if (event.Key.Keysym.Sym == Input.Keys.Escape)
                            running = false;
                        break;
                    case Sdl.EventType.WindowEvent:
                        if (event.Window.EventID == Sdl.Window.EventId.Resized)
                            GL.Viewport(0, 0, event.Window.Data1, event.Window.Data2);
                        break;
                }
            }
        }


        void Clean()
        {
            spritesheet.Dispose();
            spriteBatch.Dispose();
            Sdl.GL.DeleteContext(context);
            Sdl.Window.Destroy(window);
        }

    }
}