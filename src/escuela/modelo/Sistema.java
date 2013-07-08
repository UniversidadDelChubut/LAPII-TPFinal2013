package escuela.modelo;

import java.util.Date;
import java.util.GregorianCalendar;

public class Sistema {
	
	private static int cicloLectivoActual;
	
	static {
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Date());
		int anio = gc.get(GregorianCalendar.YEAR);
		System.out.println( anio );
	}
	
	public static int getCicloLectivoActual() {
		return cicloLectivoActual;
	}
	
	public static void setCicloLectivoActual(int cicloLectivoActual) {
		Sistema.cicloLectivoActual = cicloLectivoActual;
	}
	
}
