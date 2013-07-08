package escuela.modelo;

import java.util.List;

import escuela.EscuelaException;
import escuela.dao.AccesoADatosException;
import escuela.dao.EscuelaDAO;

public class Localidad {
	private Integer codigo;
	private String nombre;
	private String provincia;
	private Integer codigoPostal;
	public Integer getCodigo() {
		return codigo;
	}
	public void setCodigo(Integer codigo) {
		this.codigo = codigo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public Integer getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	
	public static List<Localidad> getLocalidades() throws EscuelaException {
		try {
			return new EscuelaDAO().getLocalidades();
		} catch (AccesoADatosException e) {
			throw new EscuelaException("Error al acceder a los datos", e);
		} 
	}
	
	
	@Override
	public boolean equals(Object obj) {
		return this.getCodigo().equals( ((Localidad)obj).getCodigo() );
	}
	
	@Override
	public int hashCode() {
		return this.getCodigo().hashCode();
	}
}
