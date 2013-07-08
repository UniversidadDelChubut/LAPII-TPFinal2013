package escuela.dao;

public class ObjetoInexistenteException extends AccesoADatosRuntimeException {
	public ObjetoInexistenteException (String message, Throwable cause) {
		super(message, cause);
	}
}
