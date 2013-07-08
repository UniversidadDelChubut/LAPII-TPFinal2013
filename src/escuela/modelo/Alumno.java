package escuela.modelo;

import java.util.Collection;
import java.util.Date;
import java.util.LinkedList;


public class Alumno extends Persona {
	
	private Date fechaIngreso;
	private Date fechaEgreso;
	private String motivoEgreso;
	private Collection<Curso> cursos = new LinkedList<Curso>();
	private Curso cursoActual;
	
	public Alumno() {
		
	}
	
	public void addCurso(Curso curso) {
		
		if(!this.cursos.contains(curso)){
			
			this.cursos.add(curso);
			
		}
		
		if(curso.getCicloLectivo() == Sistema.getCicloLectivoActual()){
			this.setCursoActual(curso);
		}
	}
	
	
	@Override
	public boolean equals(Object obj) {
		
		if(obj instanceof Alumno){
			
			return ((Alumno) obj).getNumeroDocumento() == this.getNumeroDocumento();
		}
		
		return false;
	}
	
	
	@Override
	public int hashCode() {
		return this.getNumeroDocumento();
	}
	
	public void setCursoActual(Curso cursoActual) {
		this.cursoActual = cursoActual;
	}
	
	public Curso getCursoActual() {
		
		return this.cursoActual;
	}

	public Date getFechaIngreso() {
		return fechaIngreso;
	}

	public void setFechaIngreso(Date fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}

	public Date getFechaEgreso() {
		return fechaEgreso;
	}

	public void setFechaEgreso(Date fechaEgreso) {
		this.fechaEgreso = fechaEgreso;
	}

	public String getMotivoEgreso() {
		return motivoEgreso;
	}

	public void setMotivoEgreso(String motivoEgreso) {
		this.motivoEgreso = motivoEgreso;
	}
	
	
	
}
