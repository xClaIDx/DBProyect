/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    private static final String URL = "jdbc:postgresql://localhost:5432/db_simulacro";
    private static final String USER = "admin_neil"; 
    private static final String PASSWORD = "Andromeda"; // <-- Pon tu contraseña real aquí

    // Este es el método que usa AlumnoDAO y HomeController
    public static Connection obtenerConexion() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("Error Driver: " + e.getMessage());
            throw new SQLException(e);
        }
    }

    // Este es el método que usa UsuarioDAO (los hacemos idénticos para que ninguno falle)
    public static Connection getConnection() throws SQLException {
        return obtenerConexion();
    }
}