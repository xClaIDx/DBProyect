package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    /**
     * Valida el ingreso de usuarios (ADMIN, DOCENTE, ALUMNO)
     */
    public Usuario validarLogin(String username, String password) {
        String sql = "SELECT id_usuario, username, password_hash, rol, estado FROM public.usuario " +
                     "WHERE username = ? AND password_hash = ? AND estado = true";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Usuario(
                        rs.getInt("id_usuario"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("rol"),
                        rs.getBoolean("estado")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en UsuarioDAO.validarLogin: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cambia la contraseña predeterminada (DNI) por una nueva
     */
    public boolean cambiarPassword(int idUsuario, String nuevaPassword) {
        String sql = "UPDATE public.usuario SET password_hash = ? WHERE id_usuario = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nuevaPassword);
            stmt.setInt(2, idUsuario);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en UsuarioDAO.cambiarPassword: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Verifica si un DNI/Username ya está registrado
     */
    public boolean existeUsername(String username) {
        String sql = "SELECT COUNT(*) FROM public.usuario WHERE username = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}