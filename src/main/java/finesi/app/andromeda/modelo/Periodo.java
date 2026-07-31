/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.modelo;

import java.sql.Date;

public class Periodo {
    private int idPeriodo;
    private String nombrePeriodo; // Ej: "2026-I" o "I Simulacro 2026"
    private int anio;              // Ej: 2026
    private int numeroCiclo;       // Ej: 1, 2, 3
    private String estado;         // 'ACTIVO' o 'CERRADO'
    private Date fechaInicio;
    private Date fechaExamen;

    public Periodo() {}

    // Getters y Setters
    public int getIdPeriodo() { return idPeriodo; }
    public void setIdPeriodo(int idPeriodo) { this.idPeriodo = idPeriodo; }

    public String getNombrePeriodo() { return nombrePeriodo; }
    public void setNombrePeriodo(String nombrePeriodo) { this.nombrePeriodo = nombrePeriodo; }

    public int getAnio() { return anio; }
    public void setAnio(int anio) { this.anio = anio; }

    public int getNumeroCiclo() { return numeroCiclo; }
    public void setNumeroCiclo(int numeroCiclo) { this.numeroCiclo = numeroCiclo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaExamen() { return fechaExamen; }
    public void setFechaExamen(Date fechaExamen) { this.fechaExamen = fechaExamen; }
}