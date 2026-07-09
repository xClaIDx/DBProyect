package finesi.app.andromeda.modelo;

public class Usuario {
    private int idUsuario;
    private String username;
    private String rol;
    private boolean estado;

    // Constructor vacío
    public Usuario() {}

    // Constructor con parámetros
    public Usuario(int idUsuario, String username, String rol, boolean estado) {
        this.idUsuario = idUsuario;
        this.username = username;
        this.rol = rol;
        this.estado = estado;
    }

    // Getters y Setters
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public boolean isEstado() { return estado; }
    public void setEstado(boolean estado) { this.estado = estado; }
}