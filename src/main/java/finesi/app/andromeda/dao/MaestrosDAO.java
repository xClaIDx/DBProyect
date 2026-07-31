/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Area;
import finesi.app.andromeda.modelo.Periodo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MaestrosDAO {

    // ==========================================
    // CRUD ÁREAS ACADÉMICAS
    // ==========================================
    public List<Area> listarAreas() {
        List<Area> lista = new ArrayList<>();
        String sql = "SELECT id_area, nombre FROM public.area ORDER BY id_area ASC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Area a = new Area();
                a.setIdArea(rs.getInt("id_area"));
                a.setNombre(rs.getString("nombre"));
                lista.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean guardarArea(String nombre) {
        String sql = "INSERT INTO public.area (nombre) VALUES (?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombre);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarArea(int idArea) {
        String sql = "DELETE FROM public.area WHERE id_area = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idArea);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // CRUD CARRERAS PROFESIONALES
    // ==========================================
    public boolean guardarCarrera(int idArea, String nombreCarrera) {
        String sql = "INSERT INTO public.carrera (id_area, nombre) VALUES (?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idArea);
            stmt.setString(2, nombreCarrera);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // CRUD PERIODOS Y EXÁMENES
    // ==========================================
    public boolean guardarPeriodo(String nombrePeriodo, int anio, int numeroCiclo) {
        String sql = "INSERT INTO public.periodo (nombre_periodo, anio, numero_ciclo, estado) VALUES (?, ?, ?, 'ACTIVO')";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombrePeriodo);
            stmt.setInt(2, anio);
            stmt.setInt(3, numeroCiclo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean guardarExamen(String nombreExamen, java.sql.Date fecha, String tipo) {
        String sql = "INSERT INTO public.examen (nombre, fecha, tipo) VALUES (?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nombreExamen);
            stmt.setDate(2, fecha);
            stmt.setString(3, tipo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Listar TODOS los períodos (para la tabla de administración)
    public List<Periodo> listarPeriodos() {
        List<Periodo> lista = new ArrayList<>();
        String sql = "SELECT id_periodo, nombre_periodo, anio, numero_ciclo, estado, fecha_inicio, fecha_examen " +
                     "FROM public.periodo ORDER BY anio DESC, numero_ciclo DESC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Periodo p = new Periodo();
                p.setIdPeriodo(rs.getInt("id_periodo"));
                p.setNombrePeriodo(rs.getString("nombre_periodo"));
                p.setAnio(rs.getInt("anio"));
                p.setNumeroCiclo(rs.getInt("numero_ciclo"));
                p.setEstado(rs.getString("estado"));
                p.setFechaInicio(rs.getDate("fecha_inicio"));
                p.setFechaExamen(rs.getDate("fecha_examen"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Obtener el Período ACTIVO vigente (para el Dashboard del Alumno)
    public Periodo obtenerPeriodoActivoVigente() {
        String sql = "SELECT id_periodo, nombre_periodo, anio, numero_ciclo, estado, fecha_inicio, fecha_examen " +
                     "FROM public.periodo WHERE estado = 'ACTIVO' ORDER BY id_periodo DESC LIMIT 1";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Periodo p = new Periodo();
                p.setIdPeriodo(rs.getInt("id_periodo"));
                p.setNombrePeriodo(rs.getString("nombre_periodo"));
                p.setAnio(rs.getInt("anio"));
                p.setNumeroCiclo(rs.getInt("numero_ciclo"));
                p.setEstado(rs.getString("estado"));
                p.setFechaInicio(rs.getDate("fecha_inicio"));
                p.setFechaExamen(rs.getDate("fecha_examen"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Crear un nuevo Simulacro / Período y ponerlo como ACTIVO (desactivando anteriores si se requiere)
    public boolean crearPeriodoSimulacro(String nombre, int anio, int ciclo, String fechaInicioStr, String fechaExamenStr) {
        String sqlCerrarAnteriores = "UPDATE public.periodo SET estado = 'CERRADO' WHERE estado = 'ACTIVO'";
        String sqlInsert = "INSERT INTO public.periodo (nombre_periodo, anio, numero_ciclo, estado, fecha_inicio, fecha_examen) " +
                           "VALUES (?, ?, ?, 'ACTIVO', CAST(? AS DATE), CAST(? AS DATE))";

        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false);

            // 1. Desactivar períodos previos
            try (PreparedStatement stmtCerrar = conn.prepareStatement(sqlCerrarAnteriores)) {
                stmtCerrar.executeUpdate();
            }

            // 2. Insertar el nuevo período activo (ej: 2026-I)
            try (PreparedStatement stmtIns = conn.prepareStatement(sqlInsert)) {
                stmtIns.setString(1, nombre);
                stmtIns.setInt(2, anio);
                stmtIns.setInt(3, ciclo);
                stmtIns.setString(4, fechaInicioStr);
                stmtIns.setString(5, fechaExamenStr);
                stmtIns.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
    }

    // Cambiar manualmente el estado de un período
    public boolean cambiarEstadoPeriodo(int idPeriodo, String estado) {
        String sql = "UPDATE public.periodo SET estado = ? WHERE id_periodo = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, estado);
            stmt.setInt(2, idPeriodo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} // <- Notice the class closing brace is now at the very end