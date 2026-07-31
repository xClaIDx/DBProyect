package finesi.app.andromeda.modelo;

import java.io.Serializable;
import java.sql.Date;

public class Alumno implements Serializable {
    private static final long serialVersionUID = 1L;

    private long idAlumno;
    private String numDocumento; // DNI
    private String nombres;
    private String apPaterno;
    private String apMaterno;
    private Date fechaNacimiento;
    private String celular;
    private String correo;
    private String ubigeoNacimiento;
    private String ubigeoDomicilio;
    private Integer idGrado;
    private Integer idSeccion;
    private Integer idUsuario;

    // Campos auxiliares para vistas
    private String nombreGrado;
    private String nombreSeccion;

    public Alumno() {
    }

    // Getters y Setters
    public long getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(long idAlumno) {
        this.idAlumno = idAlumno;
    }

    public String getNumDocumento() {
        return numDocumento;
    }

    public void setNumDocumento(String numDocumento) {
        this.numDocumento = numDocumento;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApPaterno() {
        return apPaterno;
    }

    public void setApPaterno(String apPaterno) {
        this.apPaterno = apPaterno;
    }

    public String getApMaterno() {
        return apMaterno;
    }

    public void setApMaterno(String apMaterno) {
        this.apMaterno = apMaterno;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getCelular() {
        return celular;
    }

    public void setCelular(String celular) {
        this.celular = celular;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getUbigeoNacimiento() {
        return ubigeoNacimiento;
    }

    public void setUbigeoNacimiento(String ubigeoNacimiento) {
        this.ubigeoNacimiento = ubigeoNacimiento;
    }

    public String getUbigeoDomicilio() {
        return ubigeoDomicilio;
    }

    public void setUbigeoDomicilio(String ubigeoDomicilio) {
        this.ubigeoDomicilio = ubigeoDomicilio;
    }

    public Integer getIdGrado() {
        return idGrado;
    }

    public void setIdGrado(Integer idGrado) {
        this.idGrado = idGrado;
    }

    public Integer getIdSeccion() {
        return idSeccion;
    }

    public void setIdSeccion(Integer idSeccion) {
        this.idSeccion = idSeccion;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombreGrado() {
        return nombreGrado;
    }

    public void setNombreGrado(String nombreGrado) {
        this.nombreGrado = nombreGrado;
    }

    public String getNombreSeccion() {
        return nombreSeccion;
    }

    public void setNombreSeccion(String nombreSeccion) {
        this.nombreSeccion = nombreSeccion;
    }

    public String getNombreCompleto() {
        return (nombres + " " + apPaterno + " " + apMaterno).trim();
    }
}