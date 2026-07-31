/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Docente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DocenteDAO {

    public List<Docente> listarDocentes() {
        List<Docente> lista = new ArrayList<>();
        // Cambiamos de 'calificante' a 'docente'
        String sql = "SELECT id_docente, num_documento, nombres, ap_paterno, ap_materno, especialidad " +
                     "FROM public.docente ORDER BY ap_paterno ASC";
                     
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                Docente d = new Docente();
                d.setIdDocente(rs.getInt("id_docente")); // Actualizado
                d.setNumDocumento(rs.getString("num_documento"));
                d.setNombres(rs.getString("nombres"));
                d.setApPaterno(rs.getString("ap_paterno"));
                d.setApMaterno(rs.getString("ap_materno"));
                d.setEspecialidad(rs.getString("especialidad"));
                lista.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrarDocenteConUsuario(Docente d) {
        // Se crea el usuario con ROL = DOCENTE
        String sqlUser = "INSERT INTO public.usuario (username, password, rol, estado) VALUES (?, ?, 'DOCENTE', 'ACTIVO') RETURNING id_usuario";
        
        // Se inserta directamente en la tabla docente
        String sqlDocente = "INSERT INTO public.docente (id_usuario, num_documento, nombres, ap_paterno, ap_materno, especialidad) VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false); // Transacción atómica

            int idUsuarioGenerado = 0;
            try (PreparedStatement stmtUser = conn.prepareStatement(sqlUser)) {
                stmtUser.setString(1, d.getNumDocumento());
                stmtUser.setString(2, d.getNumDocumento()); // Clave por defecto = DNI
                try (ResultSet rs = stmtUser.executeQuery()) {
                    if (rs.next()) idUsuarioGenerado = rs.getInt(1);
                }
            }

            if (idUsuarioGenerado > 0) {
                try (PreparedStatement stmtDoc = conn.prepareStatement(sqlDocente)) {
                    stmtDoc.setInt(1, idUsuarioGenerado);
                    stmtDoc.setString(2, d.getNumDocumento());
                    stmtDoc.setString(3, d.getNombres());
                    stmtDoc.setString(4, d.getApPaterno());
                    stmtDoc.setString(5, d.getApMaterno());
                    stmtDoc.setString(6, d.getEspecialidad());
                    stmtDoc.executeUpdate();
                }
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

    public boolean eliminarDocente(int idDocente) {
        // Apuntamos a la tabla docente
        String sql = "DELETE FROM public.docente WHERE id_docente = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idDocente);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}