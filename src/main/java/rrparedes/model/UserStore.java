package rrparedes.model;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * NURSELOGIC - Almacén de Usuarios en Memoria
 *
 * Simula la capa de persistencia mientras no existe base de datos.
 * En producción: reemplazar los métodos estáticos por llamadas a un DAO/BD.
 *
 * Usuarios de prueba precargados:
 *   admin       / Admin1234  -> ADMINISTRADOR
 *   enfermero1  / Nurse1234  -> ENFERMERO
 *   enfermero2  / Nurse5678  -> ENFERMERO
 */
public class UserStore {

    // Mapa principal: clave = nombreUsuario en minúsculas
    private static final Map<String, Usuario> USUARIOS = new HashMap<>();

    // ── Datos iniciales de prueba ──
    static {
        agregar("admin",      "Admin1234", "ADMINISTRADOR",
                "Administrador del Sistema", "admin@nurselogic.ec");

        agregar("enfermero1", "Nurse1234", "ENFERMERO",
                "Maria Fernanda Lopez",      "mlopez@nurselogic.ec");

        agregar("enfermero2", "Nurse5678", "ENFERMERO",
                "Carlos Eduardo Vega",       "cvega@nurselogic.ec");
    }

    // Helper interno para precarga
    private static void agregar(String user, String pass, String rol,
                                String nombre, String email) {
        USUARIOS.put(user.toLowerCase(), new Usuario(user.toLowerCase(), pass, rol, nombre, email, false));
    }

    // ─────────────────────────────────────────
    //  API pública
    // ─────────────────────────────────────────

    /**
     * Busca un usuario por nombre de usuario (insensible a mayúsculas).
     * @return Usuario o null si no existe.
     */
    public static Usuario buscarPorUsuario(String nombreUsuario) {
        if (nombreUsuario == null) return null;
        return USUARIOS.get(nombreUsuario.trim().toLowerCase());
    }

    /**
     * Valida que usuario + contraseña coincidan.
     */
    public static boolean validarCredenciales(String nombreUsuario, String contrasena) {
        Usuario u = buscarPorUsuario(nombreUsuario);
        return u != null && u.getContrasena().equals(contrasena);
    }

    /**
     * Registra un nuevo usuario.
     * @return true si se creó, false si el nombre de usuario ya existe.
     */
    public static boolean agregarUsuario(Usuario u) {
        String clave = u.getNombreUsuario().trim().toLowerCase();
        if (USUARIOS.containsKey(clave)) return false;
        USUARIOS.put(clave, u);
        return true;
    }

    /**
     * Cambia la contraseña de un usuario existente.
     * @return true si el cambio fue exitoso.
     */
    public static boolean cambiarContrasena(String nombreUsuario, String nuevaContrasena) {
        Usuario u = buscarPorUsuario(nombreUsuario);
        if (u == null) return false;
        u.setContrasena(nuevaContrasena);
        return true;
    }

    /**
     * Bloquea o desbloquea permanentemente una cuenta (por un administrador).
     */
    public static void setBloqueado(String nombreUsuario, boolean estado) {
        Usuario u = buscarPorUsuario(nombreUsuario);
        if (u != null) u.setBloqueado(estado);
    }

    /**
     * Retorna todos los usuarios (solo lectura).
     */
    public static Collection<Usuario> getTodos() {
        return USUARIOS.values();
    }

    /**
     * Verifica si un nombre de usuario ya está registrado.
     */
    public static boolean existe(String nombreUsuario) {
        return nombreUsuario != null && USUARIOS.containsKey(nombreUsuario.trim().toLowerCase());
    }
}
