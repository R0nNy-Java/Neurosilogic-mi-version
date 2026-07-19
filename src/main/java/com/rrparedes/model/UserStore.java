package com.rrparedes.model;

import com.rrparedes.dao.UsuarioDAO;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * NURSELOGIC - Almacén de Usuarios (Persistido en MySQL vía JPA UsuarioDAO)
 */
public class UserStore {

    private static final Map<String, Usuario> USUARIOS_CACHE = new HashMap<>();
    private static final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ── Precarga inicial de usuarios de prueba en MySQL si la base está vacía ──
    static {
        try {
            List<Usuario> lista = usuarioDAO.listarTodos();
            if (lista.isEmpty()) {
                agregarSemilla("admin", "Admin1234", "ADMINISTRADOR", "Administrador del Sistema", "admin@nurselogic.ec");
                agregarSemilla("enfermero1", "Nurse1234", "ENFERMERO", "Maria Fernanda Lopez", "mlopez@nurselogic.ec");
                agregarSemilla("enfermero2", "Nurse5678", "ENFERMERO", "Carlos Eduardo Vega", "cvega@nurselogic.ec");
            } else {
                for (Usuario u : lista) {
                    USUARIOS_CACHE.put(u.getNombreUsuario().toLowerCase(), u);
                }
            }
        } catch (Exception e) {
            // Silencioso si la BD aún no está lista al cargar la clase
            System.err.println("Notice: No se pudo precargar usuarios desde MySQL en static block: " + e.getMessage());
        }
    }

    private static void agregarSemilla(String user, String pass, String rol, String nombre, String email) {
        Usuario u = new Usuario(user.toLowerCase(), pass, rol, nombre, email, false);
        try {
            usuarioDAO.guardar(u);
            USUARIOS_CACHE.put(user.toLowerCase(), u);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Usuario buscarPorUsuario(String nombreUsuario) {
        if (nombreUsuario == null) return null;
        String clave = nombreUsuario.trim().toLowerCase();
        try {
            Usuario uBD = usuarioDAO.buscarPorNombreUsuario(clave);
            if (uBD != null) {
                USUARIOS_CACHE.put(clave, uBD);
                return uBD;
            }
        } catch (Exception e) {
            // Fallback a caché local si la BD aún se está iniciando
        }
        return USUARIOS_CACHE.get(clave);
    }

    public static boolean validarCredenciales(String nombreUsuario, String contrasena) {
        Usuario u = buscarPorUsuario(nombreUsuario);
        return u != null && u.getContrasena().equals(contrasena);
    }

    public static boolean agregarUsuario(Usuario u) {
        if (u == null || u.getNombreUsuario() == null) return false;
        String clave = u.getNombreUsuario().trim().toLowerCase();

        if (buscarPorUsuario(clave) != null) {
            return false;
        }

        try {
            usuarioDAO.guardar(u);
            USUARIOS_CACHE.put(clave, u);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean cambiarContrasena(String nombreUsuario, String nuevaContrasena) {
        Usuario u = buscarPorUsuario(nombreUsuario);
        if (u == null) return false;
        u.setContrasena(nuevaContrasena);
        try {
            usuarioDAO.guardar(u);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void setBloqueado(String nombreUsuario, boolean estado) {
        Usuario u = buscarPorUsuario(nombreUsuario);
        if (u != null) {
            u.setBloqueado(estado);
            try {
                usuarioDAO.guardar(u);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static Collection<Usuario> getTodos() {
        try {
            List<Usuario> lista = usuarioDAO.listarTodos();
            if (!lista.isEmpty()) {
                USUARIOS_CACHE.clear();
                for (Usuario u : lista) {
                    USUARIOS_CACHE.put(u.getNombreUsuario().toLowerCase(), u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return USUARIOS_CACHE.values();
    }

    public static boolean existe(String nombreUsuario) {
        return buscarPorUsuario(nombreUsuario) != null;
    }
}
