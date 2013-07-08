package escuela.modelo;

import java.util.Date;

public class Persona {
	
	private int numeroDocumento;
	private String apellido;
	private String nombre;
	private Date fechaNacimiento;
	private Domicilio domicilio;
	private Localidad localidadNacimiento;
	private String cuit;
	private Long telefono;
	private String email;
	
	
	public Persona() {
		
	}
	
	public void setNumeroDocumento(int numeroDocumento) {
		this.numeroDocumento = numeroDocumento;
	}
	
	public void setApellido(String apellido) {
		this.apellido = apellido;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	
	public void setDomicilio(Domicilio domicilio) {
		this.domicilio = domicilio;
	}
	
	public void setLocalidadNacimiento(Localidad localidadNacimiento) {
		this.localidadNacimiento = localidadNacimiento;
	}
	
	public void setCuit(String cuit) {
		this.cuit = cuit;
	}
	
	public void setTelefono(Long telefono) {
		this.telefono = telefono;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}

	public int getNumeroDocumento() {
		return numeroDocumento;
	}

	public String getApellido() {
		return apellido;
	}

	public String getNombre() {
		return nombre;
	}

	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}

	public Domicilio getDomicilio() {
		return domicilio;
	}

	public Localidad getLocalidadNacimiento() {
		return localidadNacimiento;
	}

	public String getCuit() {
		return cuit;
	}

	public Long getTelefono() {
		return telefono;
	}

	public String getEmail() {
		return email;
	}
	
}
