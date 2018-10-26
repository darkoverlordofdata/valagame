namespace Demo
{
    using System;
    using Microsoft.Xna.Framework;
    using System.Collections.Generic;
    #if (__EMSCRIPTEN__)
    using Jasmine;
    using Emscripten;
    using ZGL;
    #endif

    public class Program
    {
        public static void main (string[] args) 
        {
            print("Hello World\n");
            test();
            using (new Shmupwarz(), (game) => 
            {
                ((Game)game).Run();
            });
        }

    }

    static void test()
    {
        #if (__EMSCRIPTEN__)
        Describe("OpenGL Procs", () => {

            It("glOrtho should be Not Null", () => {
                Expect<bool>(ZGL.glOrtho == null).ToBe<bool>(false);
            });
            It("glFrustum should be Not Null", () => {
                Expect<bool>(ZGL.glFrustum == null).ToBe<bool>(false);
            });
            It("glPushMatrix should be Not Null", () => {
                Expect<bool>(ZGL.glPushMatrix == null).ToBe<bool>(false);
            });
            It("glPopMatrix should be Not Null", () => {
                Expect<bool>(ZGL.glPopMatrix == null).ToBe<bool>(false);
            });
            It("glVertex3f should be Not Null", () => {
                Expect<bool>(ZGL.glVertex3f == null).ToBe<bool>(false);
            });
            It("glTexCoord2f should be Not Null", () => {
                Expect<bool>(ZGL.glTexCoord2f == null).ToBe<bool>(false);
            });
            It("glGetTexLevelParameteriv should be Not Null", () => {
                Expect<bool>(ZGL.glGetTexLevelParameteriv == null).ToBe<bool>(false);
            });
            It("glDisableClientState should be Not Null", () => {
                Expect<bool>(ZGL.glDisableClientState == null).ToBe<bool>(false);
            });
            It("glBegin should be Not Null", () => {
                Expect<bool>(ZGL.glBegin == null).ToBe<bool>(false);
            });
            It("glEnd should be Not Null", () => {
                Expect<bool>(ZGL.glEnd == null).ToBe<bool>(false);
            });
        });
        var env = Jasmine.GetEnv();
        env.AddReporter(new Jasmine.ConsoleReporter());
        env.Execute();
        #endif
    }

}