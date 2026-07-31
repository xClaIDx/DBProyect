/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlumnoDAO {

    /**
     * Autoregistro completo del Alumno en transacción (Usuario DNI/DNI + Alumno)
     */
    public boolean registrarAlumnoConUsuario(Alumno alumno) {
        String sqlUsuario = "INSERT INTO public.usuario (username, password_hash, rol, estado) VALUES (?, ?, 'ALUMNO', true)";
        String sqlAlumno = "INSERT INTO public.alumno (num_documento, nombres, ap_paterno, ap_materno, fecha_nacimiento, " +
                           "celular, correo, ubigeo_nacimiento, ubigeo_domicilio, id_grado, id_seccion, id_usuario) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false); // Inicio de transacción

            // 1. Crear Usuario con DNI como clave
            int idUsuarioGenerado = 0;
            try (PreparedStatement stmtUser = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                stmtUser.setString(1, alumno.getNumDocumento());
                stmtUser.setString(2, alumno.getNumDocumento()); // Password inicial = DNI
                stmtUser.executeUpdate();

                try (ResultSet rs = stmtUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        idUsuarioGenerado = rs.getInt(1);
                    }
                }
            }

            if (idUsuarioGenerado == 0) {
                conn.rollback();
                return false;
            }

            // 2. Crear Alumno enlazado
            try (PreparedStatement stmtAlumno = conn.prepareStatement(sqlAlumno)) {
                stmtAlumno.setString(1, alumno.getNumDocumento());
                stmtAlumno.setString(2, alumno.getNombres());
                stmtAlumno.setString(3, alumno.getApPaterno());
                stmtAlumno.setString(4, alumno.getApMaterno());
                stmtAlumno.setDate(5, alumno.getFechaNacimiento());
                stmtAlumno.setString(6, alumno.getCelular());
                stmtAlumno.setString(7, alumno.getCorreo());
                stmtAlumno.setString(8, alumno.getUbigeoNacimiento());
                stmtAlumno.setString(9, alumno.getUbigeoDomicilio());
                
                if (alumno.getIdGrado() != null) stmtAlumno.setInt(10, alumno.getIdGrado()); 
                else stmtAlumno.setNull(10, java.sql.Types.INTEGER);
                
                if (alumno.getIdSeccion() != null) stmtAlumno.setInt(11, alumno.getIdSeccion()); 
                else stmtAlumno.setNull(11, java.sql.Types.INTEGER);
                
                stmtAlumno.setInt(12, idUsuarioGenerado);

                stmtAlumno.executeUpdate();
            }

            conn.commit(); // Confirmar transacción
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Error en AlumnoDAO.registrarAlumnoConUsuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
        return false;
    }

    /**
     * Lista todos los alumnos registrados en PostgreSQL
     */
    public List<Alumno> listarAlumnos() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT a.*, g.nombre AS grado_nombre, s.nombre AS seccion_nombre FROM public.alumno a " +
                     "LEFT JOIN public.grado g ON a.id_grado = g.id_grado " +
                     "LEFT JOIN public.seccion s ON a.id_seccion = s.id_seccion ORDER BY a.id_alumno DESC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearAlumno(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Obtiene el alumno por su ID primario
     */
    public Alumno obtenerAlumnoPorId(Long id) {
        String sql = "SELECT a.*, g.nombre AS grado_nombre, s.nombre AS seccion_nombre FROM public.alumno a " +
                     "LEFT JOIN public.grado g ON a.id_grado = g.id_grado " +
                     "LEFT JOIN public.seccion s ON a.id_seccion = s.id_seccion WHERE a.id_alumno = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapearAlumno(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Actualiza los datos básicos de un alumno existente
     */
    public boolean actualizarAlumno(Alumno a) {
        String sql = "UPDATE public.alumno SET num_documento=?, nombres=?, ap_paterno=?, ap_materno=? WHERE id_alumno=?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, a.getNumDocumento());
            stmt.setString(2, a.getNombres());
            stmt.setString(3, a.getApPaterno());
            stmt.setString(4, a.getApMaterno());
            stmt.setLong(5, a.getIdAlumno());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * NUEVO: Actualización Integral de Ficha del Alumno + Carrera en Postulación
     */
    public boolean actualizarAlumnoCompleto(Alumno a, int idCarrera, int idPeriodo) {
        String sqlAlumno = "UPDATE public.alumno SET " +
                            "num_documento = ?, nombres = ?, ap_paterno = ?, ap_materno = ?, " +
                            "fecha_nacimiento = ?, celular = ?, correo = ?, id_grado = ?, id_seccion = ? " +
                            "WHERE id_alumno = ?";

        String sqlPostulante = "UPDATE public.postulante SET id_carrera = ? " +
                               "WHERE id_alumno = ? AND id_periodo = ?";

        try (Connection conn = ConexionDB.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement stmtA = conn.prepareStatement(sqlAlumno);
                 PreparedStatement stmtP = conn.prepareStatement(sqlPostulante)) {

                stmtA.setString(1, a.getNumDocumento());
                stmtA.setString(2, a.getNombres());
                stmtA.setString(3, a.getApPaterno());
                stmtA.setString(4, a.getApMaterno());
                stmtA.setDate(5, a.getFechaNacimiento());
                stmtA.setString(6, a.getCelular());
                stmtA.setString(7, a.getCorreo());
                stmtA.setInt(8, a.getIdGrado());
                stmtA.setInt(9, a.getIdSeccion());
                stmtA.setLong(10, a.getIdAlumno());
                stmtA.executeUpdate();

                stmtP.setInt(1, idCarrera);
                stmtP.setLong(2, a.getIdAlumno());
                stmtP.setInt(3, idPeriodo);
                stmtP.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Elimina un alumno de la base de datos
     */
    public boolean eliminarAlumno(Long id) {
        String sql = "DELETE FROM public.alumno WHERE id_alumno = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Obtiene los datos del Alumno buscando por id_usuario
     */
    public Alumno obtenerPorIdUsuario(int idUsuario) {
        String sql = "SELECT a.*, g.nombre AS grado_nombre, s.nombre AS seccion_nombre " +
                     "FROM public.alumno a " +
                     "LEFT JOIN public.grado g ON a.id_grado = g.id_grado " +
                     "LEFT JOIN public.seccion s ON a.id_seccion = s.id_seccion " +
                     "WHERE a.id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearAlumno(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Obtiene los datos del Alumno buscando por DNI
     */
    public Alumno obtenerPorDni(String dni) {
        String sql = "SELECT a.*, g.nombre AS grado_nombre, s.nombre AS seccion_nombre " +
                     "FROM public.alumno a " +
                     "LEFT JOIN public.grado g ON a.id_grado = g.id_grado " +
                     "LEFT JOIN public.seccion s ON a.id_seccion = s.id_seccion " +
                     "WHERE a.num_documento = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, dni);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearAlumno(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Obtiene el total de alumnos registrados
     */
    public int obtenerTotalAlumnos() {
        String sql = "SELECT COUNT(*) FROM public.alumno";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Métodos auxiliares para precargar listas maestras en formularios
     */
    public Map<Integer, String> obtenerGrados() {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT id_grado, nombre FROM public.grado";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) map.put(rs.getInt("id_grado"), rs.getString("nombre"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public Map<Integer, String> obtenerPeriodosActivos() {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT id_periodo, nombre_periodo FROM public.periodo WHERE estado = 'ACTIVO'";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) map.put(rs.getInt("id_periodo"), rs.getString("nombre_periodo"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public Map<Integer, String> obtenerAreas() {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT id_area, nombre FROM public.area";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) map.put(rs.getInt("id_area"), rs.getString("nombre"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    private Alumno mapearAlumno(ResultSet rs) throws SQLException {
        Alumno a = new Alumno();
        a.setIdAlumno(rs.getLong("id_alumno"));
        a.setNumDocumento(rs.getString("num_documento"));
        a.setNombres(rs.getString("nombres"));
        a.setApPaterno(rs.getString("ap_paterno"));
        a.setApMaterno(rs.getString("ap_materno"));
        a.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
        a.setCelular(rs.getString("celular"));
        a.setCorreo(rs.getString("correo"));
        a.setUbigeoNacimiento(rs.getString("ubigeo_nacimiento"));
        a.setUbigeoDomicilio(rs.getString("ubigeo_domicilio"));
        a.setIdGrado(rs.getObject("id_grado") != null ? rs.getInt("id_grado") : null);
        a.setIdSeccion(rs.getObject("id_seccion") != null ? rs.getInt("id_seccion") : null);
        a.setIdUsuario(rs.getObject("id_usuario") != null ? rs.getInt("id_usuario") : null);
        a.setNombreGrado(rs.getString("grado_nombre"));
        a.setNombreSeccion(rs.getString("seccion_nombre"));
        return a;
    }
}