package escuela.modelo;
/*
 * contiene los datos de la clase Curso.
 */
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

import org.apache.log4j.Logger;

import escuela.EscuelaRuntimeException;
import escuela.dao.AccesoADatosException;
import escuela.dao.EscuelaDAO;
import escuela.dao.ObjetoInexistenteException;
/* Comentario de Della Torre*/
public class Curso {
	
	private static final Logger LOGGER = Logger.getLogger(Curso.class);
	
	private List<Alumno> alumnos;
	private int cicloLectivo;
	private int anio;
	private int division;
	
	
	public static List<Curso> getCursos() {
		try {
			return new EscuelaDAO().getCursos();
		} catch (AccesoADatosException e) {
			throw new EscuelaRuntimeException("Error de acceso a datos", e);
		}
	}
	
	public Curso(int cicloLectivo, int anio, int division) {
		
		this.anio = anio;
		this.cicloLectivo = cicloLectivo;
		this.division = division;
		
	}
	
	public void addAlumno(Alumno alumno) {
		
		if(!this.getAlumnos().contains(alumno)){
			this.getAlumnos().add(alumno);
			alumno.addCurso(this);
		}
		
	}
	
	
	@Override
	public boolean equals(Object obj) {
		
		if(obj instanceof Curso){
			
			Curso otroCurso = (Curso) obj;
			
			if(otroCurso.cicloLectivo == this.cicloLectivo && 
					otroCurso.anio == this.anio && 
					otroCurso.division == this.division){
				
				return true;
			}
			
		}
		
		return false;
	}
	
	@Override
	public int hashCode() {
		return (this.cicloLectivo + "" +this.anio + "" + this.division).hashCode();
	}
	
	public int getCicloLectivo() {
		return cicloLectivo;
	}
	
	public void setCicloLectivo(int cicloLectivo) {
		this.cicloLectivo = cicloLectivo;
	}

	public int getAnio() {
		return anio;
	}

	public void setAnio(int anio) {
		this.anio = anio;
	}

	public int getDivision() {
		return division;
	}

	public void setDivision(int division) {
		this.division = division;
	}
	
	public List <Alumno> getAlumnos() throws EscuelaRuntimeException {
		if (this.alumnos == null) {
			try {
				this.alumnos = new EscuelaDAO().getAlumnosDeCurso(this);
			} catch (AccesoADatosException e) {
				LOGGER.error(e, e);
				throw new EscuelaRuntimeException("Error al acceder a laos datos", e);
			}
		}
		return this.alumnos;
	}
	
	@Override
	public String toString() {
		return "Año: " + this.anio + " Division: " + this.division;
	}
	
}
