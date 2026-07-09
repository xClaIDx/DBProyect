package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    /**
     * Autentica un usuario validando sus credenciales contra la BD.
     * @param username DNI o nombre de usuario
     * @param password Contraseña en texto plano (temporalmente)
     * @return Objeto Usuario si es válido, null si las credenciales son incorrectas
     */
    public Usuario autenticar(String username, String password) {
        Usuario usuario = null;
        // Consulta segura utilizando marcadores de posición para evitar Inyección SQL
        String sql = "SELECT id_usuario, username, rol, estado FROM public.usuario WHERE username = ? AND password_hash = ? AND estado = true";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password); 

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario(
                        rs.getInt("id_usuario"),
                        rs.getString("username"),
                        rs.getString("rol"),
                        rs.getBoolean("estado")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en la autenticación: " + e.getMessage());
        }
        
        return usuario;
    }
}