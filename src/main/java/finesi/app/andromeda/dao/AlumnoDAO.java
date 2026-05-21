/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Alumno;
import finesi.app.andromeda.modelo.Area;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AlumnoDAO {
    private static final Logger LOGGER = Logger.getLogger(AlumnoDAO.class.getName());

    /**
     * Registra un alumno y lo inscribe como postulante en una sola Transacción.
     * Retorna el ID del Postulante para poder generar su certificado.
     * @param alumno
     * @return 
     */
    public Long registrarMatriculaCompleta(Alumno alumno) {
        Connection con = null;
        Long idAlumnoGenerado = null;
        Long idPostulanteGenerado = null;

        String sqlBuscarAlumno = "SELECT id_alumno FROM alumno WHERE num_documento = ?";
        String sqlInsertAlumno = "INSERT INTO alumno (num_documento, nombres, ap_paterno, ap_materno, fecha_nacimiento, id_grado) VALUES (?, ?, ?, ?, ?, ?) RETURNING id_alumno";
        String sqlInsertPostulante = "INSERT INTO postulante (id_alumno, id_carrera, id_periodo) VALUES (?, ?, ?) RETURNING id_postulante";

        try {
            con = ConexionDB.obtenerConexion();
            con.setAutoCommit(false); 

            // 1. Buscar alumno
            try (PreparedStatement psBuscar = con.prepareStatement(sqlBuscarAlumno)) {
                psBuscar.setString(1, alumno.getNumDocumento());
                ResultSet rs = psBuscar.executeQuery();
                if (rs.next()) idAlumnoGenerado = rs.getLong("id_alumno");
            }

            // 2. Insertar alumno si no existe
            if (idAlumnoGenerado == null) {
                try (PreparedStatement psAlumno = con.prepareStatement(sqlInsertAlumno)) {
                    psAlumno.setString(1, alumno.getNumDocumento());
                    psAlumno.setString(2, alumno.getNombres());
                    psAlumno.setString(3, alumno.getApPaterno());
                    psAlumno.setString(4, alumno.getApMaterno());
                    psAlumno.setDate(5, java.sql.Date.valueOf(alumno.getFechaNacimiento()));
                    psAlumno.setInt(6, alumno.getIdGrado());
                    ResultSet rsNuevo = psAlumno.executeQuery();
                    if (rsNuevo.next()) idAlumnoGenerado = rsNuevo.getLong("id_alumno");
                }
            }

            // 3. Insertar postulante
            if (idAlumnoGenerado != null) {
                try (PreparedStatement psPostulante = con.prepareStatement(sqlInsertPostulante)) {
                    psPostulante.setLong(1, idAlumnoGenerado);
                    psPostulante.setInt(2, alumno.getIdCarrera());
                    psPostulante.setInt(3, alumno.getIdPeriodo());
                    ResultSet rsPost = psPostulante.executeQuery();
                    if (rsPost.next()) idPostulanteGenerado = rsPost.getLong("id_postulante");
                }
            }

            con.commit();
            return idPostulanteGenerado;
        } catch (SQLException e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) {}
            LOGGER.log(Level.SEVERE, "Error en matrícula", e);
            return null;
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ex) {}
        }
    }

    public List<Alumno> listarAlumnos() {
        List<Alumno> lista = new ArrayList<>();
        
        // 1. Obtenemos la conexión con Try-with-resources
        try (Connection con = ConexionDB.obtenerConexion()) {
            
            if (con != null) {
                // 2. Usamos el QueryBuilder en lugar de escribir "SELECT * FROM..." a mano
                QueryBuilder query = new QueryBuilder("alumno")
                                        .orderByDesc("id_alumno");
                
                // 3. Ejecutamos el Fetch pasándole nuestra conexión actual
                try (ResultSet rs = query.fetch(con)) {
                    
                    // 4. Mapeamos el resultado a objetos Alumno (Igual que antes)
                    while (rs.next()) {
                        Alumno alumno = new Alumno();
                        alumno.setIdAlumno(rs.getLong("id_alumno"));
                        alumno.setNumDocumento(rs.getString("num_documento"));
                        alumno.setNombres(rs.getString("nombres"));
                        alumno.setApPaterno(rs.getString("ap_paterno"));
                        alumno.setApMaterno(rs.getString("ap_materno"));
                        // ... (resto de tus mapeos) ...
                        
                        lista.add(alumno);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo en la ejecucion SQL al listar.", e);
        }
        
        return lista;
    }
    
    /**
     * Elimina un alumno de la base de datos según su ID.
     * @param idAlumno El identificador único del alumno.
     * @return true si se eliminó correctamente, false en caso de error.
     */
    public boolean eliminarAlumno(Long idAlumno) {
        // La consulta SQL de borrado usando el parámetro seguro (?)
        String sql = "DELETE FROM alumno WHERE id_alumno = ?";
        
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            // Inyectamos el ID en la consulta
            ps.setLong(1, idAlumno);
            
            // executeUpdate() devuelve el número de filas afectadas. 
            // Si es mayor a 0, significa que se borró con éxito.
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo al eliminar el alumno con ID: " + idAlumno, e);
            return false;
        }
    }
    
    /**
     * Busca un alumno específico por su ID para llenar el formulario de edición.
     * @param idAlumno
     */
    public Alumno obtenerAlumnoPorId(Long idAlumno) {
        Alumno alumno = null;
        String sql = "SELECT * FROM alumno WHERE id_alumno = ?";
        
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setLong(1, idAlumno);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    alumno = new Alumno();
                    alumno.setIdAlumno(rs.getLong("id_alumno"));
                    alumno.setNumDocumento(rs.getString("num_documento"));
                    alumno.setNombres(rs.getString("nombres"));
                    alumno.setApPaterno(rs.getString("ap_paterno"));
                    alumno.setApMaterno(rs.getString("ap_materno"));
                    // (Si tienes más campos como fecha o grado, agrégalos aquí)
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo al buscar alumno con ID: " + idAlumno, e);
        }
        return alumno;
    }
    
    
    /**
     * Extrae todos los datos cruzados (Joins) de la base de datos para pintar el Certificado.
     * @param numDocumento
     * @return 
     */
    public Alumno obtenerDatosCertificado(String numDocumento) {
        Alumno certificado = null;
        
        // El poder de una base de datos relacional bien estructurada
        String sql = "SELECT a.num_documento, a.nombres, a.ap_paterno, a.ap_materno, "
                   + "g.nombre AS nombre_grado, c.nombre AS nombre_carrera, "
                   + "ar.nombre AS nombre_area, p.nombre_periodo "
                   + "FROM alumno a "
                   + "INNER JOIN grado g ON a.id_grado = g.id_grado "
                   + "INNER JOIN postulante pos ON a.id_alumno = pos.id_alumno "
                   + "INNER JOIN carrera c ON pos.id_carrera = c.id_carrera "
                   + "INNER JOIN area ar ON c.id_area = ar.id_area "
                   + "INNER JOIN periodo p ON pos.id_periodo = p.id_periodo "
                   + "WHERE a.num_documento = ? "
                   + "ORDER BY pos.fecha_inscripcion DESC LIMIT 1";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, numDocumento);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    certificado = new Alumno();
                    certificado.setNumDocumento(rs.getString("num_documento"));
                    certificado.setNombres(rs.getString("nombres"));
                    certificado.setApPaterno(rs.getString("ap_paterno"));
                    certificado.setApMaterno(rs.getString("ap_materno"));
                    
                    // Inyectamos los datos cruzados a nuestro DTO
                    certificado.setNombreGrado(rs.getString("nombre_grado"));
                    certificado.setNombreCarrera(rs.getString("nombre_carrera"));
                    certificado.setNombreArea(rs.getString("nombre_area"));
                    certificado.setNombrePeriodo(rs.getString("nombre_periodo"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo al generar datos del certificado", e);
        }
        return certificado;
    }

    /**
     * Actualiza los datos de un alumno existente en la base de datos.
     * @param alumno
     * @return 
     */
    public boolean actualizarAlumno(Alumno alumno) {
        String sql = "UPDATE alumno SET num_documento = ?, nombres = ?, ap_paterno = ?, ap_materno = ? WHERE id_alumno = ?";
        
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, alumno.getNumDocumento());
            ps.setString(2, alumno.getNombres());
            ps.setString(3, alumno.getApPaterno());
            ps.setString(4, alumno.getApMaterno());
            ps.setLong(5, alumno.getIdAlumno()); // El ID va al final para el WHERE
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo al actualizar alumno: " + alumno.getIdAlumno(), e);
            return false;
        }
    }
    
    /**
     * Calcula el total de postulantes registrados en el sistema.
     * Ideal para las tarjetas de métricas (KPIs) del Dashboard.
     * @return 
     */
    public int obtenerTotalAlumnos() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM alumno";
        
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                total = rs.getInt("total"); // Extraemos el alias 'total'
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo al contar el total de alumnos", e);
        }
        
        return total;
    }

    public boolean registrarAlumno(Alumno nuevoAlumno) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    
    /**
    * Obtiene todos los grados activos para el formulario
     * @return 
    */
    public Map<Integer, String> obtenerGrados() {
        Map<Integer, String> grados = new LinkedHashMap<>();
        String sql = "SELECT id_grado, nombre FROM grado WHERE permite_inscripcion = true";
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) grados.put(rs.getInt("id_grado"), rs.getString("nombre"));
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error grados", e); }
        return grados;
    }

    public Map<Integer, String> obtenerPeriodosActivos() {
        Map<Integer, String> periodos = new LinkedHashMap<>();
        String sql = "SELECT id_periodo, nombre_periodo, anio FROM periodo WHERE estado = 'ACTIVO'";
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String label = rs.getString("nombre_periodo") + " " + rs.getInt("anio");
                periodos.put(rs.getInt("id_periodo"), label);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error periodos", e); }
        return periodos;
    }

    public List<Area> obtenerAreas() {
        List<Area> lista = new ArrayList<>();
        String sql = "SELECT id_area, nombre FROM area";
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Area area = new Area();
                area.setIdArea(rs.getInt("id_area"));
                area.setNombre(rs.getString("nombre"));
                lista.add(area);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
    
    
}