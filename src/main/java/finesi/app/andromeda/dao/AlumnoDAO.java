/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.dao;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Alumno;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AlumnoDAO {

    private static final Logger LOGGER = Logger.getLogger(AlumnoDAO.class.getName());

    public boolean registrarAlumno(Alumno alumno) {
        String sql = "INSERT INTO alumno (num_documento, nombres, ap_paterno, ap_materno, fecha_nacimiento, celular, correo, id_grado, id_seccion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Primer nivel: Obtenemos y aseguramos el cierre de la conexion
        try (Connection con = ConexionDB.obtenerConexion()) {
            
            // Validacion de seguridad para evitar NullPointerException
            if (con == null) {
                LOGGER.severe("[ERROR] Conexion nula. No se puede registrar el alumno.");
                return false;
            }
            
            // Segundo nivel: Preparamos la sentencia solo si la conexion es valida
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, alumno.getNumDocumento());
                ps.setString(2, alumno.getNombres());
                ps.setString(3, alumno.getApPaterno());
                ps.setString(4, alumno.getApMaterno());
                ps.setDate(5, java.sql.Date.valueOf(alumno.getFechaNacimiento()));
                ps.setString(6, alumno.getCelular());
                ps.setString(7, alumno.getCorreo());
                ps.setInt(8, alumno.getIdGrado());
                ps.setInt(9, alumno.getIdSeccion());
                
                return ps.executeUpdate() > 0;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo en la ejecucion SQL al registrar.", e);
            return false;
        }
    }

    public List<Alumno> listarAlumnos() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT * FROM alumno ORDER BY id_alumno DESC";
        
        try (Connection con = ConexionDB.obtenerConexion()) {
            
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    
                    while (rs.next()) {
                        Alumno alumno = new Alumno();
                        
                        alumno.setIdAlumno(rs.getLong("id_alumno"));
                        alumno.setNumDocumento(rs.getString("num_documento"));
                        alumno.setNombres(rs.getString("nombres"));
                        alumno.setApPaterno(rs.getString("ap_paterno"));
                        alumno.setApMaterno(rs.getString("ap_materno"));
                        
                        if (rs.getDate("fecha_nacimiento") != null) {
                            alumno.setFechaNacimiento(rs.getDate("fecha_nacimiento").toLocalDate());
                        }
                        
                        alumno.setCelular(rs.getString("celular"));
                        alumno.setCorreo(rs.getString("correo"));
                        alumno.setIdGrado(rs.getInt("id_grado"));
                        alumno.setIdSeccion(rs.getInt("id_seccion"));
                        
                        lista.add(alumno);
                    }
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[ERROR] Fallo en la ejecucion SQL al listar.", e);
        }
        
        return lista;
    }
}