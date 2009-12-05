package rpc.util;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

// @license

/**
 * @author pcdavid
 */
public class GetEnv {
    public static Map getEnvironment() {
        Map env = new HashMap();
        LineNumberReader reader = null;
        try {
            reader = new LineNumberReader(new FileReader("/proc/self/environ"));
            String[] lines = reader.readLine().split("\000");
            for (int i = 0; i < lines.length; i++) {
                String line = lines[i];
                int n = line.indexOf('=');
                env.put(line.substring(0, n), line.substring(n+1));
            }            
        } catch (Exception e) {
            return null;
        } finally {
            try {
                if (reader != null)
                    reader.close();
            } catch (IOException ioe) {
                /* ignore */
            }
        }
        return env;
    }
    
    public static String getEnv(String varName) {
        return (String) getEnvironment().get(varName); 
    }
    
    public static void main(String[] args) {
        Map env = GetEnv.getEnvironment();
        for (Iterator iter = env.keySet().iterator(); iter.hasNext();) {
            String var= (String) iter.next();
            System.out.println(var + "=" + env.get(var));
        }
    }
}

