/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

/*import finesi.app.andromeda.conexion.ConexionDB;*/
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Constructor de consultas SQL dinámicas (Inspirado en el proyecto demo-db).
 * Nos permite armar consultas paso a paso de forma segura contra Inyecciones SQL.
 */
public class QueryBuilder {
    
    private final String tabla;
    private final List<Condition> condiciones = new ArrayList<>();
    private String orderBy;
    private boolean ascendente = true;

    // Clase interna para guardar las condiciones (WHERE id = ?)
    protected class Condition {
        String columna, operador, logica;
        Object valor;

        Condition(String c, String o, Object v, String l) {
            columna = c; operador = o; valor = v; logica = l;
        }
    }

    // Constructor que recibe la tabla a consultar
    public QueryBuilder(String tabla) {
        this.tabla = tabla;
    }

    // Métodos encadenables (Patrón Fluent Interface)
    public QueryBuilder where(String col, Object val) {
        condiciones.add(new Condition(col, "=", val, "WHERE"));
        return this;
    }

    public QueryBuilder orderByDesc(String col) {
        this.orderBy = col;
        this.ascendente = false;
        return this;
    }

    /**
     * Ejecuta la consulta y retorna el ResultSet.
     * IMPORTANTE: En un entorno real, devolver un ResultSet directo requiere 
     * manejar bien el cierre de conexiones. Lo usaremos para alimentar el DAO.
     * @param con La conexión a la base de datos PostgreSQL  
     * @return El ResultSet con los datos obtenidos
     * @throws SQLException Si hay un error en la consulta
     */
    public ResultSet fetch(Connection con) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM " + tabla);
        List<Object> parametros = new ArrayList<>();

        // 1. Armar las condiciones WHERE
        if (!condiciones.isEmpty()) {
            sql.append(" WHERE ");
            for (int i = 0; i < condiciones.size(); i++) {
                Condition c = condiciones.get(i);
                if (i > 0) sql.append(" ").append(c.logica).append(" ");
                
                // Agregamos la columna de forma segura
                if (c.columna.matches("^[a-zA-Z0-9_]+$")) {
                    sql.append(c.columna).append(" ").append(c.operador).append(" ?");
                    parametros.add(c.valor);
                }
            }
        }

        // 2. Armar el ORDER BY
        if (orderBy != null && orderBy.matches("^[a-zA-Z0-9_]+$")) {
            sql.append(" ORDER BY ").append(orderBy).append(ascendente ? " ASC" : " DESC");
        }

        // 3. Preparar el Statement inyectando las variables (?)
        PreparedStatement ps = con.prepareStatement(sql.toString());
        for (int i = 0; i < parametros.size(); i++) {
            ps.setObject(i + 1, parametros.get(i));
        }

        // Retornamos el resultado (El DAO se encargará de cerrarlo)
        return ps.executeQuery();
    }
}