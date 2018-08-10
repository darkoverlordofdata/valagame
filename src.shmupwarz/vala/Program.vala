namespace Demo
{
    using System;
    using Microsoft.Xna.Framework;
    using System.Collections.Generic;
    using System.Xml;
    using System.IO;

    public void __LexDummy__(){}
    public void Test()
    {
      //  var x = new System.Xml.XmlDocument(xml);
      //  print("=========================\n");
      //  print("%s\n", x.DocNode.ToString());
      //  print("=========================\n");

        var parser = new SaxDriver();
        var handler = new MetaSpriteHandler();
        parser.SetDocumentHandler(handler);
        parser.SetErrorHandler(handler);
        parser.SetLexicalHandler(handler);
        parser.Parse(new FileHandle("./MetaSprite.xml").Read());
        print("type: %s\n", handler.TypeName);
        print("data: %f %f\n", 
            MetaSprite.MetaSpriteDict["spr/Link/Attack"].Speed[0],
            MetaSprite.MetaSpriteDict["spr/Link/Attack"].Anchor.X);
      
    }
    
    public class Program
    {
        public static void main (string[] args) 
        {
            // using (new Shmupwarz(), (game) => 
            // {
            //     ((Game)game).Run();
            // });
            Test();
        }
    }

    public class MetaSprite : Object
    {
        public static Dictionary<string, MetaSprite> MetaSpriteDict { get; set; }
        public float[] Speed { get; set; }
        public Vector2? Anchor { get; set; }

        // public static void LoadContent(ContentManager contentManager)
        // {
        //     MetaSpriteDict = contentManager.Load<Dictionary<string, MetaSprite>>("MetaSprite.xml");
        // }
    }


    public class MetaSpriteHandler : DefaultHandler
    {
        public string TypeName;
        string tagName;
        string key;
        float[] speed;
        Vector2 anchor;
        string[] tmp;

        public MetaSpriteHandler()
        {
            MetaSprite.MetaSpriteDict = new Dictionary<string, MetaSprite>();
        }

        public override void StartElement(string tagName, SaxDriver attr){
            this.tagName = tagName;
            if (tagName == "Asset")
            {
                TypeName = attr.GetValueByName("Type");
            }
        }
        
        public override void EndElement(string tagName){
            if (tagName == "Item")
            {
                var s = new MetaSprite();
                s.Speed = new float[speed.length];
                for (var i=0; i<speed.length; i++)
                    s.Speed[i] = speed[i];
                s.Anchor = anchor.Copy();
                MetaSprite.MetaSpriteDict[key] = s;

                key = "";
                speed = new float[0];
                anchor = Vector2.Zero;
            }
        }

        public override void Characters(string data, int start, int len){
            if (SaxStrings.IndexOfNonWhitespace(data.substring(start, len)) >= 0)
            {
                switch (tagName)
                {
                    case "Key":
                        key = data.substring(start, len);
                        break;

                    case "Speed": 
                        tmp = data.substring(start, len).split(" ");
                        speed = new float[tmp.length];
                        var i = 0;
                        foreach (var s in tmp) {
                            speed[i++] = (float)double.parse(s);
                        }
                        break;
                    
                    case "Anchor":
                        tmp = data.substring(start, len).split(" ");
                        anchor = new Vector2((float)double.parse(tmp[0]), (float)double.parse(tmp[1]));
                        break;

                    default:
                        break;
                }
            }
        }
    }
}
