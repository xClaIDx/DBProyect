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

public class ExamenDAO {

    /**
     * Obtiene las Áreas Académicas reales registradas en PostgreSQL
     */
    public List<Area> listarAreas() {
        List<Area> lista = new ArrayList<>();
        String sql = "SELECT id_area, nombre FROM public.area ORDER BY id_area ASC";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Area area = new Area();
                area.setIdArea(rs.getInt("id_area"));
                area.setNombre(rs.getString("nombre"));
                lista.add(area);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Asigna un docente/calificante a la gestión de aula/periodo en log
     */
    public boolean asignarDocenteAula(int idDocente, int idPeriodo, String aula) {
    // Actualizado: id_docente en lugar de id_calificante
    String sql = "INSERT INTO public.log_calificacion (id_docente, id_periodo, accion_realizada) " +
                 "VALUES (?, ?, ?)";
    try (Connection conn = ConexionDB.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, idDocente);
        stmt.setInt(2, idPeriodo);
        stmt.setString(3, "ASIGNACION_AULA: " + aula);
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
    }
}