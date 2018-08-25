import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.FileInputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
public class Hello {

    public static void main(String[] args) {

        // Prints "Hello, World" to the terminal window.
        System.out.println("Hello, World");
                     //C:\\Users\\darko\\Documents\\GitHub\\valagame\\src
        String name = "C:\\Users\\darko\\Documents\\GitHub\\valagame\\src\\README.md";
        System.out.println(name);
        try 
        {
            BufferedReader doc = new BufferedReader(new InputStreamReader(new FileInputStream(name)));
            int c;
            int i = 0;
            while ((c = doc.read()) >= 0)
            {
                System.out.print((char)c);
                i++;
            }
            doc.close();
            System.out.printf("count %d\n", i);
            
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
        
        Pattern pattern = Pattern.compile("vala");
        Matcher matcher = pattern.matcher("this is vala do you know vala no do you");
        boolean found = false;
        while (matcher.find())
        {
            System.out.printf("Text: %s\n", matcher.group());
            System.out.printf("start: %d\n", matcher.start());
            System.out.printf("end: %d\n", matcher.end());
            found = true;
        }
        System.out.printf("found = %s\n", found);

        String regexString = "vala";
        String thisString = "this is vala do you know vala no do you";
        String replacementString = "java";
        String resultString = Pattern.compile(regexString).matcher(thisString).replaceAll(replacementString);
        System.out.printf("Replace = %s\n", resultString);


    }

}