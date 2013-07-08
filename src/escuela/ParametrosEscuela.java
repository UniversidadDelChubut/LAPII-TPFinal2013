package escuela;

import java.io.FileInputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

public class ParametrosEscuela {
	
	private static Logger LOGGER = Logger.getLogger(ParametrosEscuela.class);

	private static Properties props;
	
	static {
		try {
			props = new Properties();
			FileInputStream in = new FileInputStream("escuela.properties");
			props.load(in);
			in.close();
		} catch (Exception ex) {
			LOGGER.fatal(ex, ex);
		}	
	}
	
	
	public static String [] getParametrosDeConexion(){
		
		String [] retval = new String[3];
		retval[0] = props.getProperty("url");
		retval[1] = props.getProperty("user");
		retval[2] = props.getProperty("pass");
			
		return retval;
	}
	
}


