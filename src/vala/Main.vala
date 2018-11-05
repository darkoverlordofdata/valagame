//  https://gitlab.com/Partanen/KTL_SpriteBatch
/**
 * Not sure why the linker wants a WinMain, but ok...
 */
public int WinMain(string[] args)
{
    print("Hello WinMain\n");
    var game = new Demo.Game();
    return 0;
}
public static int main (string[] args) 
{
    print("Hello World\n");
    return 0;
}

namespace Demo
{
    using System;
    using ValaGame.OpenGL;
    using System.Collections.Generic;
    using Microsoft.Xna.Framework;
    using Microsoft.Xna.Framework.Graphics;

    public class Game : Object
    {
        const int SCREEN_WIDTH = 800;
        const int SCREEN_HEIGHT = 600;
        const int VERSION = 300;
        const string PROFILE = "es";

        bool running;
        IntPtr window;
        IntPtr gl_context;
        KTL.SpriteBatch spriteBatch;
        Texture2D spritesheet;
        Rectangle tile_clip1 = new Rectangle(0, 0, 32, 32);
        Rectangle tile_clip2 = new Rectangle(0, 32, 32, 32);

        

        public Game()
        {
            Init();

            for (running = true; running;)
            {
                Update();
                Render();
            }
            Clean();

        }

        public void Init()
        {
            Sdl.Init(Sdl.InitFlags.Video);
            Sdl.GL.SetAttribute(Sdl.GL.Attribute.ContextMajorVersion, VERSION/10);
            Sdl.GL.SetAttribute(Sdl.GL.Attribute.ContextMajorVersion, (VERSION%100)/10);
            Sdl.GL.SetAttribute(Sdl.GL.Attribute.DoubleBuffer, 1);

            window = Sdl.Window.Create("SDL2 example",
                                    (int)Sdl.Window.SDL_WINDOWPOS_CENTERED,
                                    (int)Sdl.Window.SDL_WINDOWPOS_CENTERED,
                                    SCREEN_WIDTH, SCREEN_HEIGHT,
                                    Sdl.Window.State.OpenGL);
                                    
            gl_context = Sdl.GL.CreateContext(window);
            Sdl.GL.SetSwapInterval(0);
            GL.LoadEntryPoints();

            GL.Enable(EnableCap.Blend);
            GL.BlendFunc(BlendingFactorSrc.SrcAlpha, BlendingFactorDest.OneMinusSrcAlpha);

            spritesheet = new Texture2D();
            spritesheet.SetData("spritesheet.png");

            spriteBatch = new KTL.SpriteBatch();
            spriteBatch.Create(); // initialize the sprite spriteBatch

        }


        void Render()
        {
            GL.ClearColor(0.129f, 0.463f, 1.0f, 1.0f);
            GL.Clear(ClearBufferMask.ColorBufferBit);

            int mid_x = SCREEN_WIDTH/2  - 16;
            int mid_y = SCREEN_HEIGHT/2 - 16;

            int ticks  = (int)Sdl.GetTicks();
            float floating  = 2 * Math.sinf((float)(ticks * 1.75f * Math.PI / 5f));
            int y_add       = (int)floating;
            var ONE = new Vector2(1f, 1f);

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
            Sdl.GL.DeleteContext(gl_context);
            Sdl.Window.Destroy(window);
        }

    }
}