/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Clase de conexion a la base de datos.
 * Ahora proporciona una conexion individual por cada transaccion,
 * previniendo errores de concurrencia en entornos web (Servlets).
 */
public class ConexionDB {

    private static final String URL = "jdbc:postgresql://localhost:5432/db_simulacro";
    private static final String USUARIO = "admin_neil";
    private static final String CONTRASENA = "Andromeda";

    private static final Logger LOGGER = Logger.getLogger(ConexionDB.class.getName());

    public static Connection obtenerConexion() {
        Connection conexionNueva = null;
        try {
            Class.forName("org.postgresql.Driver");
            conexionNueva = DriverManager.getConnection(URL, USUARIO, CONTRASENA);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] No se encontro el driver de PostgreSQL.", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo la conexion a la base de datos.", e);
        }
        return conexionNueva;
    }
}