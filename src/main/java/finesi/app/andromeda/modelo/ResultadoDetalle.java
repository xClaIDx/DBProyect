/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package finesi.app.andromeda.modelo;

import java.io.Serializable;
import java.math.BigDecimal;

public class ResultadoDetalle implements Serializable {
    private static final long serialVersionUID = 1L;

    private long idResultado;
    private long idPostulante;
    private long idAlumno;
    private int idExamen;
    
    // Conteo de preguntas
    private int correctas;
    private int incorrectas;
    private int vacias;

    // Desglose de Notas por Criterio Oficial
    private BigDecimal notaCompetencias; // Max 60.00
    private BigDecimal notaPsicotecnico;  // Max 20.00
    private BigDecimal notaRedaccion;     // Max 10.00
    private BigDecimal notaEntrevista;    // Max 10.00
    private BigDecimal puntajeTotal;     // Max 100.00

    // Datos del Alumno y Proceso
    private String numDocumento;
    private String nombreAlumno;
    private String gradoSeccion;
    private String areaPostulacion;
    private String carreraProfesional;
    private String nombreExamen;
    private String fechaExamen;
    private Integer posicionGeneral;
    private Integer posicionCarrera;
    private String areaAcademica;

    public ResultadoDetalle() {
        this.notaCompetencias = BigDecimal.ZERO;
        this.notaPsicotecnico = BigDecimal.ZERO;
        this.notaRedaccion = BigDecimal.ZERO;
        this.notaEntrevista = BigDecimal.ZERO;
        this.puntajeTotal = BigDecimal.ZERO;
    }

    // Getters y Setters
    public long getIdResultado() {
        return idResultado;
    }

    public void setIdResultado(long idResultado) {
        this.idResultado = idResultado;
    }

    public long getIdPostulante() {
        return idPostulante;
    }

    public void setIdPostulante(long idPostulante) {
        this.idPostulante = idPostulante;
    }

    public long getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(long idAlumno) {
        this.idAlumno = idAlumno;
    }

    public int getIdExamen() {
        return idExamen;
    }

    public void setIdExamen(int idExamen) {
        this.idExamen = idExamen;
    }

    public int getCorrectas() {
        return correctas;
    }

    public void setCorrectas(int correctas) {
        this.correctas = correctas;
    }

    public int getIncorrectas() {
        return incorrectas;
    }

    public void setIncorrectas(int incorrectas) {
        this.incorrectas = incorrectas;
    }

    public int getVacias() {
        return vacias;
    }

    public void setVacias(int vacias) {
        this.vacias = vacias;
    }

    public BigDecimal getNotaCompetencias() {
        return notaCompetencias;
    }

    public void setNotaCompetencias(BigDecimal notaCompetencias) {
        this.notaCompetencias = notaCompetencias;
    }

    public BigDecimal getNotaPsicotecnico() {
        return notaPsicotecnico;
    }

    public void setNotaPsicotecnico(BigDecimal notaPsicotecnico) {
        this.notaPsicotecnico = notaPsicotecnico;
    }

    public BigDecimal getNotaRedaccion() {
        return notaRedaccion;
    }

    public void setNotaRedaccion(BigDecimal notaRedaccion) {
        this.notaRedaccion = notaRedaccion;
    }

    public BigDecimal getNotaEntrevista() {
        return notaEntrevista;
    }

    public void setNotaEntrevista(BigDecimal notaEntrevista) {
        this.notaEntrevista = notaEntrevista;
    }

    public BigDecimal getPuntajeTotal() {
        return puntajeTotal;
    }

    public void setPuntajeTotal(BigDecimal puntajeTotal) {
        this.puntajeTotal = puntajeTotal;
    }

    public String getNumDocumento() {
        return numDocumento;
    }
    
    public String getAreaAcademica() {
    return areaAcademica;
    }

    public void setNumDocumento(String numDocumento) {
        this.numDocumento = numDocumento;
    }

    public String getNombreAlumno() {
        return nombreAlumno;
    }

    public void setNombreAlumno(String nombreAlumno) {
        this.nombreAlumno = nombreAlumno;
    }

    public String getGradoSeccion() {
        return gradoSeccion;
    }

    public void setGradoSeccion(String gradoSeccion) {
        this.gradoSeccion = gradoSeccion;
    }
    
    public void setAreaAcademica(String areaAcademica) {
    this.areaAcademica = areaAcademica;
    }

    public String getAreaPostulacion() {
        return areaPostulacion;
    }

    public void setAreaPostulacion(String areaPostulacion) {
        this.areaPostulacion = areaPostulacion;
    }

    public String getCarreraProfesional() {
        return carreraProfesional;
    }

    public void setCarreraProfesional(String carreraProfesional) {
        this.carreraProfesional = carreraProfesional;
    }

    public String getNombreExamen() {
        return nombreExamen;
    }

    public void setNombreExamen(String nombreExamen) {
        this.nombreExamen = nombreExamen;
    }

    public String getFechaExamen() {
        return fechaExamen;
    }

    public void setFechaExamen(String fechaExamen) {
        this.fechaExamen = fechaExamen;
    }

    public Integer getPosicionGeneral() {
        return posicionGeneral;
    }

    public void setPosicionGeneral(Integer posicionGeneral) {
        this.posicionGeneral = posicionGeneral;
    }

    public Integer getPosicionCarrera() {
        return posicionCarrera;
    }

    public void setPosicionCarrera(Integer posicionCarrera) {
        this.posicionCarrera = posicionCarrera;
    }
}
