namespace ZeldaPlatformer
{
    using System;
    using Microsoft.Xna.Framework;
    using System.Collections.Generic;
    using System.IO;
    using System.JSON;
    using System.Regex;
    
    public class Program
    {
        Object lock;

        public static void main(string[] args)
        {
            System.Initialize();
            Test();
            // using (new Game(), (game) => 
            // {
            //     ((Game)game).Run();
            // });

        }
        public static void Test()
        {
            

            var cwd = new char[1024];
            var s2 = (string)Dir.cwd(cwd);
            var name = s2+"\\assets\\Test.json";
            // var doc = new FileInputStream(name);
            // var doc = new InputStreamReader(new FileInputStream(name));
            // var doc = new BufferedInputStream(new FileInputStream(name));
            try 
            {
                var doc = new BufferedInputStream(new FileInputStream(name));
                int c;
                string str = "";
                while ((c = doc.ReadOne()) >= 0)
                {
                    str += string.char(c);
                    // println("%c",(char)c);
                }
                doc.Close();
                var json = new JSONObject(str);
                println("%s", json.ToString());
                var ptr = json.OptQuery("/height");
                println("%d", ((Number)ptr).IntValue());
                var ary = json.OptQuery("/layers/0/data");
                println("%s", ary.ToString());
                println("%d", ((JSONArray)ary).GetInt(22));
            }
            catch (System.IOException e)
            {
                println(e.message);
            }
            println("-ff = %d", Integer.ParseInt("-ff", 16));
            println("kona = %d", Integer.ParseInt("kona", 27));


            // Pattern p = Pattern.Compile("a*b");
            Pattern p = Pattern.Compile("b*a");
            Matcher m = p.GetMatcher("aaaaab");
            bool b = m.Matches();

            println("matches %s", b.to_string());

            bool b2 = Pattern.Matches("a*b", "aaaaab");  

            println("matches %s", b2.to_string());

            println("digits %s", Pattern.Matches("[789]{1}[0-9]{9}", "9953038949").to_string());

            println("digits %s", Pattern.Matches("[789][0-9]{9}", "99530389490").to_string());


            var pattern = Pattern.Compile("vala");
            var matcher = pattern.GetMatcher("this is vala do you know vala no do you");
            var found = false;
            while (matcher.Find())
            {
                println("Text: %s", matcher.Group());
                println("start: %d", matcher.Start());
                println("end: %d", matcher.End());
                found = true;
            }
            println("found = %s", found.to_string());

            println("this is vala do you know vala no do you"
                        .ReplaceAll("\\p{valaLowerCase}", "x"));

            println("this is vala do you know vala no do you"
                        .ReplaceAll("vala", "java"));

            println("this is vala do you know vala no do you"
                        .ReplaceAll("(do) you", "$1 I"));

            var EMAIL = "(?i)^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$";

            if ("tux@kernel.org".Matches(EMAIL))
                println("Valid!");
            else
                println("Invalid!");

            if (" true".Matches("\\s*true$"))
                println("Valid!");
            else
                println("Invalid!");

            // if (/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.match(email)) {
            //     stdout.printf("Valid email address\n");
            // }            
            foreach (var sss in "a1b2c3d".Split("\\d"))  
                println(@"\"$sss\"");

            foreach (var sss in "a,b,c,d".Split(","))  
                println(@"\"$sss\"");

        }
    }
}


public string FArrayToString(float[] f)
{
    var s  = new StringBuilder("{");
    var b = 0;
    var e = f.length-1;
    foreach (var f1 in f)
    {
        s.append(f1.to_string());
        if (b++ < e)
            s.append(", ");
    }
    s.append("}");
    return s.str;

}

