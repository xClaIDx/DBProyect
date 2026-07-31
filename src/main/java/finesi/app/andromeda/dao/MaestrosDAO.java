/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Area;

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
}