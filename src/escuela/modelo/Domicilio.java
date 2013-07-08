package escuela.modelo;

public class Domicilio {
	
	private String calle;
	private int altura;
	private Localidad ciudad;
	
	public Domicilio() {
		
	}
	
	public Domicilio(String calle, int altura, Localidad ciudad) {
		super();
		this.calle = calle;
		this.altura = altura;
		this.ciudad = ciudad;
	}
	
	@Override
	public String toString() {
		return this.calle + " " + this.altura + " " +  this.ciudad.getNombre() + " (CP " + this.ciudad.getCodigoPostal() + ")";
	}
	
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public int getAltura() {
		return altura;
	}
	public void setAltura(int altura) {
		this.altura = altura;
	}
	public Localidad getCiudad() {
		return ciudad;
	}
	public void setCiudad(Localidad ciudad) {
		this.ciudad = ciudad;
	}
	
	
	
	
}
