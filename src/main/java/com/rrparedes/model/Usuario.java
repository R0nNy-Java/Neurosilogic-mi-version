package com.rrparedes.model;

/**
 * NURSELOGIC - Modelo de Usuario
 * Representa un usuario del sistema con sus atributos de seguridad.
 */
public class Usuario {

    private String  nombreUsuario;
    private String  contrasena;
    private String  rol;              // "ENFERMERO" | "ADMINISTRADOR"
    private String  nombreCompleto;
    private String  email;
    private boolean bloqueado;        // bloqueo permanente por administrador

    public Usuario(String nombreUsuario, String contrasena, String rol,
                   String nombreCompleto, String email, boolean bloqueado) {
        this.nombreUsuario  = nombreUsuario;
        this.contrasena     = contrasena;
        this.rol            = rol;
        this.nombreCompleto = nombreCompleto;
        this.email          = email;
        this.bloqueado      = bloqueado;
    }

    // ── Getters ──
    public String  getNombreUsuario()  { return nombreUsuario; }
    public String  getContrasena()     { return contrasena; }
    public String  getRol()            { return rol; }
    public String  getNombreCompleto() { return nombreCompleto; }
    public String  getEmail()          { return email; }
    public boolean isBloqueado()       { return bloqueado; }

    // ── Setters permitidos ──
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }
    public void setBloqueado(boolean bloqueado)  { this.bloqueado  = bloqueado;  }
    public void setRol(String rol)               { this.rol        = rol;        }
}
