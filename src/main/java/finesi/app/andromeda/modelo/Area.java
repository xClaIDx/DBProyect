/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.modelo;

public class Area {
    // 1. Variables (Atributos)
    private Integer idArea;
    private String nombre;

    // 2. Constructor vacío
    public Area() {
    }

    // 3. Getters y Setters (Esto es lo que el DAO está buscando y no encuentra)
    public Integer getIdArea() {
        return idArea;
    }

    public void setIdArea(Integer idArea) {
        this.idArea = idArea;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}
