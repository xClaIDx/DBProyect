/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.modelo;

import java.time.LocalDate;

/**
 * Clase Modelo (POJO) para la tabla Alumno.
 * Su única responsabilidad es almacenar y transportar datos.
 */
public class Alumno {

    private Long idAlumno;
    private String numDocumento;
    private String nombres;
    private String apPaterno;
    private String apMaterno;
    private LocalDate fechaNacimiento;
    private String celular;
    private String correo;
    private String ubigeoNacimiento;
    private String ubigeoDomicilio;
    private Integer idGrado;
    private Integer idSeccion;

    // Constructor vacío (Obligatorio para que Java pueda instanciar la clase dinámicamente)
    public Alumno() {
    }

    // Constructor completo (Útil para crear objetos Alumno rápidamente en una sola línea)
    public Alumno(Long idAlumno, String numDocumento, String nombres, String apPaterno, String apMaterno, LocalDate fechaNacimiento, String celular, String correo, String ubigeoNacimiento, String ubigeoDomicilio, Integer idGrado, Integer idSeccion) {
        this.idAlumno = idAlumno;
        this.numDocumento = numDocumento;
        this.nombres = nombres;
        this.apPaterno = apPaterno;
        this.apMaterno = apMaterno;
        this.fechaNacimiento = fechaNacimiento;
        this.celular = celular;
        this.correo = correo;
        this.ubigeoNacimiento = ubigeoNacimiento;
        this.ubigeoDomicilio = ubigeoDomicilio;
        this.idGrado = idGrado;
        this.idSeccion = idSeccion;
    }

    // ==========================================
    // GETTERS Y SETTERS
    // ==========================================

    public Long getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(Long idAlumno) {
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

    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(LocalDate fechaNacimiento) {
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
}