package finesi.app.andromeda.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // Configuración de la base de datos PostgreSQL
    private static final String URL = "jdbc:postgresql://localhost:5432/db_simulacro";
    private static final String USER = "admin_neil"; // Cambia según tu usuario local de Postgres
    private static final String PASS = "admin";      // Cambia según tu contraseña local de Postgres

    static {
        try {
            // Carga del Driver JDBC de PostgreSQL
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver de PostgreSQL no encontrado en el classpath.");
            e.printStackTrace();
        }
    }

    /**
     * Obtiene una nueva conexión a la base de datos PostgreSQL.
     * @return Connection objeto de conexión SQL
     * @throws SQLException si ocurre un error de conexión
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Método auxiliar para cerrar la conexión de forma segura.
     * @param conn Objeto Connection a cerrar
     */
    public static void cerrarConexion(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}