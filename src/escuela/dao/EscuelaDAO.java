package escuela.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import escuela.ParametrosEscuela;
import escuela.modelo.Alumno;
import escuela.modelo.Curso;
import escuela.modelo.Domicilio;
import escuela.modelo.Localidad;
import escuela.modelo.Persona;

public class EscuelaDAO {
	
	private static Logger LOGGER = Logger.getLogger(EscuelaDAO.class);
	
	private static Map<Integer, Localidad > cacheLocalidades = new HashMap<Integer, Localidad>();
	
	
	private Connection cnn;
	
	static {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			LOGGER.fatal(e, e);
		}
	}
	
	
	
	private static Connection getConnection() {
		String[] params = ParametrosEscuela.getParametrosDeConexion();
		try {
			return DriverManager.getConnection(params[0], params[1], params[2]);
		} catch (SQLException e) {
			LOGGER.error(e, e);
		}
		return null;
	}
	
	private boolean openConnection() {
		if (this.cnn != null)
			return false;
		this.cnn = EscuelaDAO.getConnection();
		return true;
	}
	
	private void closeConnection()  {
		if (this.cnn != null) {
			try {
				this.cnn.close();
				this.cnn = null;
			} catch (SQLException e) {
				LOGGER.warn(e, e);
			}
		}
			
	}
	
	private void setDatosPersonales (Persona persona, ResultSet rs) throws SQLException , AccesoADatosException {
		persona.setNumeroDocumento(rs.getInt("numero_documento"));
		persona.setNombre(rs.getString("nombre"));
		persona.setApellido(rs.getString("apellido"));
		persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
		Domicilio domicilio = new Domicilio(rs.getString("domicilio_calle"), rs.getInt("domicilio_altura"), this.getLocalidad(rs.getInt("domicilio_localidad")) );
		persona.setDomicilio( domicilio );
		persona.setLocalidadNacimiento( this.getLocalidad(rs.getInt("localidad_nacimiento")));
		persona.setCuit(rs.getString("cuit"));
		persona.setTelefono(rs.getLong("telefono"));
		if (rs.wasNull())
			persona.setTelefono(null);
		persona.setEmail(rs.getString("email"));
		
	}
	
	public Localidad getLocalidad (int codigo) throws AccesoADatosException, ObjetoInexistenteException {
		
		
		if (cacheLocalidades.containsKey(codigo)){
			return cacheLocalidades.get(codigo);
		}
		
		Localidad localidad = null;
		String sql = "SELECT codigo, nombre, provincia, codigo_postal FROM localidad WHERE codigo = ?";
		
		boolean cerrar = this.openConnection();
		try {
			PreparedStatement pstmt = cnn.prepareStatement(sql);
			pstmt.setInt(1, codigo);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()){
				localidad = new Localidad();
				localidad.setCodigo(codigo);
				localidad.setCodigoPostal( rs.getInt("codigo_postal") );
				localidad.setNombre( rs.getString("nombre"));
				localidad.setProvincia(rs.getString("provincia"));
			} else {
				throw new ObjetoInexistenteException("No existe una localidad con codigo " + codigo, null);
			}
		} catch (SQLException ex) {
			throw new AccesoADatosException ("No se pudo obtener la localidad con codigo " + codigo, ex);
		} finally {
			if (cerrar)
				this.closeConnection();
		}	
		
		cacheLocalidades.put(localidad.getCodigo(), localidad);
		return localidad;
	}

	
	public List<Localidad> getLocalidades () throws AccesoADatosException{
		
		List<Localidad> localidades = new LinkedList<Localidad>();
		
		String sql = "SELECT codigo, nombre, provincia, codigo_postal FROM localidad ORDER BY nombre";
		
		boolean cerrar = this.openConnection();
		try {
			PreparedStatement pstmt = cnn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				Localidad localidad = null;
				if (cacheLocalidades.containsKey(rs.getInt("codigo"))){
					localidad = cacheLocalidades.get(rs.getInt("codigo"));
				} else {
					localidad = new Localidad();
					localidad.setCodigo(rs.getInt("codigo"));
					localidad.setCodigoPostal( rs.getInt("codigo_postal") );
					localidad.setNombre( rs.getString("nombre"));
					localidad.setProvincia(rs.getString("provincia"));
					cacheLocalidades.put(localidad.getCodigo(), localidad);	
				}
				localidades.add(localidad); 
			}
		} catch (SQLException ex) {
			throw new AccesoADatosException ("Error al obtener las localidades", ex);
		} finally {
			if (cerrar)
				this.closeConnection();
		}	
		return localidades;
	}
	
	
	
	public Alumno getAlumno(String tipoDocumento, int numeroDocumento) throws AccesoADatosException, ObjetoInexistenteException {
		
		Alumno alumno = null;
		
		String sql = 
				" SELECT " +
				"		p.numero_documento, p.apellido, p.nombre, " +
				" 		p.fecha_nacimiento, p.domicilio_calle, p.domicilio_altura, p.domicilio_localidad, " +
				"		p.localidad_nacimiento, p.cuit, p.telefono, p.email, " +
				"		a.fecha_ingreso, a.fecha_egreso, a.motivo_egreso " +
				" FROM persona p, alumno a " +
				" WHERE " +
				"		a.numero_documento = p.numero_documento AND " +
				"		a.tipo_documento = p.tipo_documento AND " +
				"		a.tipo_documento = ? AND a.numero_documento = ?;";	
		
		boolean cerrar = this.openConnection();
		try {
			PreparedStatement pstmt = cnn.prepareStatement(sql);
			pstmt.setString (1, tipoDocumento);
			pstmt.setInt(2, numeroDocumento);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()){
				alumno = new Alumno();
				alumno.setNumeroDocumento(numeroDocumento);
				this.setDatosPersonales(alumno, rs);
				alumno.setFechaIngreso( rs.getDate("fecha_ingreso") );
				alumno.setFechaEgreso( rs.getDate("fecha_egreso") );
				if (rs.wasNull())
					alumno.setFechaEgreso(null);
				alumno.setMotivoEgreso( rs.getString("motivo_egreso"));
				if (rs.wasNull())
					alumno.setMotivoEgreso(null);
				
			} else {
				throw new ObjetoInexistenteException("No existe un alumno con documento " + numeroDocumento, null);
			}
		} catch (SQLException ex) {
			throw new AccesoADatosException ("No se pudo obtener el alumno con documento " + numeroDocumento, ex);
		} finally {
			if (cerrar)
				this.closeConnection();
		}
		return alumno;
	}
	
	
	public void guardar (Localidad localidad) throws AccesoADatosException {
		boolean cerrar = this.openConnection();
		try {
			PreparedStatement pstmt = cnn.prepareStatement(
					" UPDATE localidad " +
					" SET" +
					"	nombre = ?," +
					"	provincia = ?," +
					"	codigo_postal = ?  " +
					" WHERE	" +
					"	codigo = ? " 
					);
			
			
			pstmt.setString(1, localidad.getNombre());
			pstmt.setString(2, localidad.getProvincia());
			pstmt.setInt(3, localidad.getCodigoPostal());
			pstmt.setInt(4, localidad.getCodigo());
			pstmt.executeUpdate();
			cacheLocalidades.put(localidad.getCodigo(), localidad);
		} catch (SQLException ex) {
			throw new AccesoADatosException ("No se pudo obtener la localidad con codigo ", ex);
		} finally {
			if (cerrar)
				this.closeConnection();
		}	
	}
	
	
	
	
	public List <Curso> getCursos() throws AccesoADatosException {
		List <Curso> cursos =  new LinkedList<Curso>();
		
		String sql = "SELECT anio, division, ciclo_lectivo FROM curso ORDER BY ciclo_lectivo, anio, division";
		
		boolean cerrar = this.openConnection();
		try {
			PreparedStatement pstmt = cnn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()){
				Curso curso = new Curso(
						rs.getInt("ciclo_lectivo"),
						rs.getInt("anio"),
						rs.getInt("division")
						);
				cursos.add(curso); 
			}
		} catch (SQLException ex) {
			throw new AccesoADatosException ("Error al obtener los cursos", ex);
		} finally {
			if (cerrar)
				this.closeConnection();
		}	
		return cursos;
	}
	
	
	public List<Alumno> getAlumnosDeCurso(Curso curso) throws AccesoADatosException {
		List <Alumno> alumnos =  new LinkedList<Alumno>();
		
		String sql = 
				" SELECT a.tipo_documento, a.numero_documento " +
				" FROM " +
				"	alumno_curso ac, alumno a, persona p " +
				" WHERE " +
				"	a.tipo_documento = ac.tipo_documento AND " +
				"	a.numero_documento = ac.numero_documento AND " +
				"	a.tipo_documento = p.tipo_documento AND " +
				"	a.numero_documento = p.numero_documento  AND " +
				"	anio = ? AND division = ? AND ciclo_lectivo =? " +
				" ORDER BY apellido, nombre ";
		
		boolean cerrar = this.openConnection();
		try {
			PreparedStatement pstmt = cnn.prepareStatement(sql);
			pstmt.setInt(1, curso.getAnio());
			pstmt.setString(2, curso.getDivision()+ "");
			pstmt.setInt(3, curso.getCicloLectivo());
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()){
				Alumno alumno = this.getAlumno(rs.getString("tipo_documento"), rs.getInt("numero_documento"));
				alumnos.add(alumno); 
			}
		} catch (SQLException ex) {
			throw new AccesoADatosException ("Error al obtener los alumnos de un curso", ex);
		} finally {
			if (cerrar)
				this.closeConnection();
		}	
		return alumnos;
		
	}
	
	
	
}
