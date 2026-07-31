/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Postulante;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PostulanteDAO {

    /**
     * Inscribe a un alumno en una carrera y periodo activo
     */
    public boolean inscribirSimulacro(long idAlumno, int idCarrera, int idPeriodo) {
        String sql = "INSERT INTO public.postulante (id_alumno, id_carrera, id_periodo) VALUES (?, ?, ?)";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idAlumno);
            stmt.setInt(2, idCarrera);
            stmt.setInt(3, idPeriodo);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al inscribir postulante (posible duplicado): " + e.getMessage());
            return false;
        }
    }

    /**
     * Consulta la inscripción activa de un postulante en un período específico
     */
    public Postulante obtenerPostulacion(long idAlumno, int idPeriodo) {
        String sql = "SELECT p.*, a.num_documento, (a.nombres || ' ' || a.ap_paterno || ' ' || a.ap_materno) AS nombre_alumno, " +
                     "c.nombre AS carrera_nombre, ar.nombre AS area_nombre, per.nombre_periodo " +
                     "FROM public.postulante p " +
                     "JOIN public.alumno a ON p.id_alumno = a.id_alumno " +
                     "JOIN public.carrera c ON p.id_carrera = c.id_carrera " +
                     "JOIN public.area ar ON c.id_area = ar.id_area " +
                     "JOIN public.periodo per ON p.id_periodo = per.id_periodo " +
                     "WHERE p.id_alumno = ? AND p.id_periodo = ?";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idAlumno);
            stmt.setInt(2, idPeriodo);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Postulante post = new Postulante();
                    post.setIdPostulante(rs.getLong("id_postulante"));
                    post.setIdAlumno(rs.getLong("id_alumno"));
                    post.setIdCarrera(rs.getInt("id_carrera"));
                    post.setIdPeriodo(rs.getInt("id_periodo"));
                    post.setFechaInscripcion(rs.getTimestamp("fecha_inscripcion"));
                    post.setNumDocumento(rs.getString("num_documento"));
                    post.setNombreAlumno(rs.getString("nombre_alumno"));
                    post.setNombreCarrera(rs.getString("carrera_nombre"));
                    post.setNombreArea(rs.getString("area_nombre"));
                    post.setNombrePeriodo(rs.getString("nombre_periodo"));
                    return post;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * [DOCENTE] Listar postulantes filtrados por un período específico
     */
    public List<Postulante> listarPorPeriodo(int idPeriodo) {
        List<Postulante> lista = new ArrayList<>();
        String sql = "SELECT p.*, a.num_documento, (a.nombres || ' ' || a.ap_paterno || ' ' || a.ap_materno) AS nombre_alumno, " +
                     "c.nombre AS carrera_nombre, ar.nombre AS area_nombre, per.nombre_periodo " +
                     "FROM public.postulante p " +
                     "JOIN public.alumno a ON p.id_alumno = a.id_alumno " +
                     "JOIN public.carrera c ON p.id_carrera = c.id_carrera " +
                     "JOIN public.area ar ON c.id_area = ar.id_area " +
                     "JOIN public.periodo per ON p.id_periodo = per.id_periodo " +
                     "WHERE p.id_periodo = ? " +
                     "ORDER BY a.ap_paterno ASC, a.ap_materno ASC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idPeriodo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Postulante post = new Postulante();
                    post.setIdPostulante(rs.getLong("id_postulante"));
                    post.setIdAlumno(rs.getLong("id_alumno"));
                    post.setIdCarrera(rs.getInt("id_carrera"));
                    post.setIdPeriodo(rs.getInt("id_periodo"));
                    post.setFechaInscripcion(rs.getTimestamp("fecha_inscripcion"));
                    post.setNumDocumento(rs.getString("num_documento"));
                    post.setNombreAlumno(rs.getString("nombre_alumno"));
                    post.setNombreCarrera(rs.getString("carrera_nombre"));
                    post.setNombreArea(rs.getString("area_nombre"));
                    post.setNombrePeriodo(rs.getString("nombre_periodo"));
                    lista.add(post);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * [ESTUDIANTE] Listar todo el historial de postulaciones/inscripciones de un alumno
     */
    public List<Postulante> listarHistorialPorAlumno(long idAlumno) {
        List<Postulante> lista = new ArrayList<>();
        String sql = "SELECT p.*, a.num_documento, (a.nombres || ' ' || a.ap_paterno || ' ' || a.ap_materno) AS nombre_alumno, " +
                     "c.nombre AS carrera_nombre, ar.nombre AS area_nombre, per.nombre_periodo " +
                     "FROM public.postulante p " +
                     "JOIN public.alumno a ON p.id_alumno = a.id_alumno " +
                     "JOIN public.carrera c ON p.id_carrera = c.id_carrera " +
                     "JOIN public.area ar ON c.id_area = ar.id_area " +
                     "JOIN public.periodo per ON p.id_periodo = per.id_periodo " +
                     "WHERE p.id_alumno = ? " +
                     "ORDER BY p.id_periodo DESC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Postulante post = new Postulante();
                    post.setIdPostulante(rs.getLong("id_postulante"));
                    post.setIdAlumno(rs.getLong("id_alumno"));
                    post.setIdCarrera(rs.getInt("id_carrera"));
                    post.setIdPeriodo(rs.getInt("id_periodo"));
                    post.setFechaInscripcion(rs.getTimestamp("fecha_inscripcion"));
                    post.setNumDocumento(rs.getString("num_documento"));
                    post.setNombreAlumno(rs.getString("nombre_alumno"));
                    post.setNombreCarrera(rs.getString("carrera_nombre"));
                    post.setNombreArea(rs.getString("area_nombre"));
                    post.setNombrePeriodo(rs.getString("nombre_periodo"));
                    lista.add(post);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * [ADMIN/DOCENTE] Listar todos los postulantes inscritos
     */
    public List<Postulante> listarTodos() {
        List<Postulante> lista = new ArrayList<>();
        String sql = "SELECT p.*, a.num_documento, (a.nombres || ' ' || a.ap_paterno || ' ' || a.ap_materno) AS nombre_alumno, " +
                     "c.nombre AS carrera_nombre, ar.nombre AS area_nombre, per.nombre_periodo " +
                     "FROM public.postulante p " +
                     "JOIN public.alumno a ON p.id_alumno = a.id_alumno " +
                     "JOIN public.carrera c ON p.id_carrera = c.id_carrera " +
                     "JOIN public.area ar ON c.id_area = ar.id_area " +
                     "JOIN public.periodo per ON p.id_periodo = per.id_periodo " +
                     "ORDER BY p.fecha_inscripcion DESC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Postulante post = new Postulante();
                post.setIdPostulante(rs.getLong("id_postulante"));
                post.setIdAlumno(rs.getLong("id_alumno"));
                post.setIdCarrera(rs.getInt("id_carrera"));
                post.setIdPeriodo(rs.getInt("id_periodo"));
                post.setFechaInscripcion(rs.getTimestamp("fecha_inscripcion"));
                post.setNumDocumento(rs.getString("num_documento"));
                post.setNombreAlumno(rs.getString("nombre_alumno"));
                post.setNombreCarrera(rs.getString("carrera_nombre"));
                post.setNombreArea(rs.getString("area_nombre"));
                post.setNombrePeriodo(rs.getString("nombre_periodo"));
                lista.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * [ADMIN] Modificar la carrera asignada a una inscripción
     */
    public boolean modificarCarrera(long idPostulante, int nuevaCarrera) {
        String sql = "UPDATE public.postulante SET id_carrera = ? WHERE id_postulante = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nuevaCarrera);
            stmt.setLong(2, idPostulante);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * [ADMIN] Eliminar la inscripción de un estudiante
     */
    public boolean eliminarPostulante(long idPostulante) {
        String sql = "DELETE FROM public.postulante WHERE id_postulante = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, idPostulante);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}