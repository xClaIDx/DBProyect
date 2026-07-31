/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.ResultadoDetalle;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ResultadoDAO {

    /**
     * Guardar o actualizar la calificación desglosada por los 4 criterios
     */
    public boolean guardarOCalificar(ResultadoDetalle rd, int idDocente, int idPeriodo) {
        String sqlUpsert = 
            "INSERT INTO public.resultado (id_postulante, id_alumno, id_examen, correctas, incorrectas, vacias, " +
            "nota_competencias, nota_psicotecnico, nota_redaccion, nota_entrevista, puntaje_total) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
            "ON CONFLICT (id_resultado) DO UPDATE SET " +
            "correctas = EXCLUDED.correctas, incorrectas = EXCLUDED.incorrectas, vacias = EXCLUDED.vacias, " +
            "nota_competencias = EXCLUDED.nota_competencias, nota_psicotecnico = EXCLUDED.nota_psicotecnico, " +
            "nota_redaccion = EXCLUDED.nota_redaccion, nota_entrevista = EXCLUDED.nota_entrevista, " +
            "puntaje_total = EXCLUDED.puntaje_total";

        String sqlLog = "INSERT INTO public.log_calificacion (id_docente, id_postulante, id_periodo, accion_realizada) " +
                        "VALUES (?, ?, ?, ?)";

        // Suma del Puntaje Total
        BigDecimal total = rd.getNotaCompetencias()
                            .add(rd.getNotaPsicotecnico())
                            .add(rd.getNotaRedaccion())
                            .add(rd.getNotaEntrevista());
        rd.setPuntajeTotal(total);

        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement stmtRes = conn.prepareStatement(sqlUpsert);
                 PreparedStatement stmtLog = conn.prepareStatement(sqlLog)) {
                
                stmtRes.setLong(1, rd.getIdPostulante());
                stmtRes.setLong(2, rd.getIdAlumno());
                stmtRes.setInt(3, rd.getIdExamen());
                stmtRes.setInt(4, rd.getCorrectas());
                stmtRes.setInt(5, rd.getIncorrectas());
                stmtRes.setInt(6, rd.getVacias());
                stmtRes.setBigDecimal(7, rd.getNotaCompetencias());
                stmtRes.setBigDecimal(8, rd.getNotaPsicotecnico());
                stmtRes.setBigDecimal(9, rd.getNotaRedaccion());
                stmtRes.setBigDecimal(10, rd.getNotaEntrevista());
                stmtRes.setBigDecimal(11, rd.getPuntajeTotal());

                stmtRes.executeUpdate();

                // Auditoría en log_calificacion
                stmtLog.setInt(1, idDocenteValido(conn, idDocente));
                stmtLog.setLong(2, rd.getIdPostulante());
                stmtLog.setInt(3, idPeriodo);
                stmtLog.setString(4, "CALIFICACION_REGISTRADA: Total=" + total);

                stmtLog.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException ex) {
                if (conn != null) conn.rollback();
                ex.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConexionDB.cerrarConexion(conn);
        }
        return false;
    }

    /**
     * Obtiene el resultado completo de un alumno por DNI para el certificado de resultados
     */
    public ResultadoDetalle obtenerResultadoPorDni(String dni) {
        ResultadoDetalle r = null;
        String sql = "WITH RankingGeneral AS (" +
                     "    SELECT " +
                     "        r.id_alumno, " +
                     "        a.num_documento, " +
                     "        (a.nombres || ' ' || a.ap_paterno || ' ' || a.ap_materno) AS nombre_completo, " +
                     "        COALESCE(c.nombre, 'General') AS carrera, " +
                     "        COALESCE(ar.nombre, 'Ingenierías') AS area, " +
                     "        per.nombre_periodo, " +
                     "        r.nota_competencias, " +
                     "        r.nota_psicotecnico, " +
                     "        r.nota_redaccion, " +
                     "        r.nota_entrevista, " +
                     "        r.puntaje_total, " +
                     "        DENSE_RANK() OVER (ORDER BY r.puntaje_total DESC) AS puesto_general " +
                     "    FROM public.resultado r " +
                     "    INNER JOIN public.alumno a ON r.id_alumno = a.id_alumno " +
                     "    LEFT JOIN public.postulante p ON a.id_alumno = p.id_alumno " +
                     "    LEFT JOIN public.periodo per ON p.id_periodo = per.id_periodo " +
                     "    LEFT JOIN public.carrera c ON p.id_carrera = c.id_carrera " +
                     "    LEFT JOIN public.area ar ON c.id_area = ar.id_area " +
                     ") " +
                     "SELECT * FROM RankingGeneral WHERE num_documento = ? LIMIT 1;";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, dni);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    r = new ResultadoDetalle();
                    r.setNumDocumento(rs.getString("num_documento"));
                    r.setNombreAlumno(rs.getString("nombre_completo"));
                    r.setCarreraProfesional(rs.getString("carrera"));
                    r.setAreaAcademica(rs.getString("area"));
                    r.setNombreExamen(rs.getString("nombre_periodo"));
                    r.setNotaCompetencias(rs.getBigDecimal("nota_competencias"));
                    r.setNotaPsicotecnico(rs.getBigDecimal("nota_psicotecnico"));
                    r.setNotaRedaccion(rs.getBigDecimal("nota_redaccion"));
                    r.setNotaEntrevista(rs.getBigDecimal("nota_entrevista"));
                    r.setPuntajeTotal(rs.getBigDecimal("puntaje_total"));
                    r.setPosicionGeneral(rs.getInt("puesto_general"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    /**
     * Obtiene la lista completa de rankings ordenada por puntaje descendente.
     */
    public List<ResultadoDetalle> listarRankings() {
        return listarRankingsPorPeriodo(null);
    }

    /**
     * Obtiene la lista de rankings filtrada dinámicamente por Período Académico (idPeriodo)
     */
    public List<ResultadoDetalle> listarRankingsPorPeriodo(Integer idPeriodo) {
        List<ResultadoDetalle> lista = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "    r.id_alumno, " +
            "    a.num_documento, " +
            "    (a.nombres || ' ' || a.ap_paterno || ' ' || a.ap_materno) AS nombre_completo, " +
            "    COALESCE(c.nombre, 'General') AS carrera, " +
            "    COALESCE(ar.nombre, 'Ingenierías') AS area, " +
            "    COALESCE(per.nombre_periodo, 'Simulacro General') AS nombre_periodo, " +
            "    r.nota_competencias, " +
            "    r.nota_psicotecnico, " +
            "    r.nota_redaccion, " +
            "    r.nota_entrevista, " +
            "    r.puntaje_total, " +
            "    DENSE_RANK() OVER (ORDER BY r.puntaje_total DESC) AS puesto_general " +
            "FROM public.resultado r " +
            "INNER JOIN public.alumno a ON r.id_alumno = a.id_alumno " +
            "LEFT JOIN public.postulante p ON a.id_alumno = p.id_alumno " +
            "LEFT JOIN public.periodo per ON p.id_periodo = per.id_periodo " +
            "LEFT JOIN public.carrera c ON p.id_carrera = c.id_carrera " +
            "LEFT JOIN public.area ar ON c.id_area = ar.id_area "
        );

        if (idPeriodo != null && idPeriodo > 0) {
            sql.append("WHERE p.id_periodo = ? ");
        }

        sql.append("ORDER BY r.puntaje_total DESC");

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (idPeriodo != null && idPeriodo > 0) {
                stmt.setInt(1, idPeriodo);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ResultadoDetalle r = new ResultadoDetalle();
                    r.setNumDocumento(rs.getString("num_documento"));
                    r.setNombreAlumno(rs.getString("nombre_completo"));
                    r.setCarreraProfesional(rs.getString("carrera"));
                    r.setAreaAcademica(rs.getString("area"));
                    r.setNombreExamen(rs.getString("nombre_periodo"));
                    r.setNotaCompetencias(rs.getBigDecimal("nota_competencias"));
                    r.setNotaPsicotecnico(rs.getBigDecimal("nota_psicotecnico"));
                    r.setNotaRedaccion(rs.getBigDecimal("nota_redaccion"));
                    r.setNotaEntrevista(rs.getBigDecimal("nota_entrevista"));
                    r.setPuntajeTotal(rs.getBigDecimal("puntaje_total"));
                    r.setPosicionGeneral(rs.getInt("puesto_general"));
                    lista.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Busca un id_docente válido o retorna 1 por defecto
     */
    private int idDocenteValido(Connection conn, int idUser) {
        String sql = "SELECT id_docente FROM public.docente LIMIT 1";
        try (Statement st = conn.createStatement(); 
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Fallback silencioso
        }
        return 1;
    }
}