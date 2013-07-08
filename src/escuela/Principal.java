package escuela;

import escuela.dao.AccesoADatosException;
import escuela.dao.EscuelaDAO;
import escuela.dao.ObjetoInexistenteException;
import escuela.modelo.Alumno;
import escuela.modelo.Curso;

public class Principal {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		EscuelaDAO dao = new EscuelaDAO();
		ParametrosEscuela escuela = new ParametrosEscuela();
		
		try {
			for (Curso c: Curso.getCursos()){
				System.out.println(c.getAnio() +  " " + c.getDivision() + " " +  c.getCicloLectivo());
				for (Alumno alu: c.getAlumnos() ){
					System.out.println("   " + alu.getApellido() + " " + alu.getNombre());
				}
			}
			
			/*
			Alumno a = dao.getAlumno("DNI", 36322082);
			System.out.println(a.getNombre() + " " + a.getApellido() + " -> " + a.getDomicilio());
			*/
			
			
		} catch (ObjetoInexistenteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}

}
