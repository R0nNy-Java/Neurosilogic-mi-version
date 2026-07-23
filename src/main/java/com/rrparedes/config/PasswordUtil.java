package com.rrparedes.config;

import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * NURSELOGIC – PasswordUtil
 *
 * Utilidad para el hash y verificación segura de contraseñas usando
 * PBKDF2 con HMAC-SHA256 (misma familia de algoritmo usada en SISGEST).
 *
 * Formato de almacenamiento (una sola columna ContrasenaHash):
 *   iteraciones:saltBase64:hashBase64
 *
 * Uso:
 *   String hash = PasswordUtil.hash("miContrasena123");
 *   boolean ok   = PasswordUtil.verificar("miContrasena123", hash);
 */
public final class PasswordUtil {

    private static final int    ITERACIONES   = 65536;
    private static final int    LONGITUD_HASH = 256; // bits
    private static final int    LONGITUD_SAL  = 16;  // bytes
    private static final String ALGORITMO     = "PBKDF2WithHmacSHA256";

    private PasswordUtil() {
        // Clase de utilidades, no instanciable
    }

    /**
     * Genera el hash seguro de una contraseña en texto plano.
     * El resultado ya incluye las iteraciones y la sal, listo para
     * guardarse directamente en la columna ContrasenaHash.
     */
    public static String hash(String contrasenaPlano) {
        try {
            byte[] sal = generarSal();
            byte[] hash = pbkdf2(contrasenaPlano.toCharArray(), sal, ITERACIONES, LONGITUD_HASH);

            return ITERACIONES + ":" + Base64.getEncoder().encodeToString(sal)
                    + ":" + Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Error al generar el hash de la contraseña", e);
        }
    }

    /**
     * Verifica si una contraseña en texto plano corresponde al hash
     * almacenado. Es tolerante con contraseñas antiguas guardadas en
     * texto plano (migración progresiva): si el valor almacenado no
     * tiene el formato "iteraciones:sal:hash", se compara texto plano.
     */
    public static boolean verificar(String contrasenaPlano, String hashAlmacenado) {
        if (contrasenaPlano == null || hashAlmacenado == null) return false;

        String[] partes = hashAlmacenado.split(":");
        if (partes.length != 3) {
            // Compatibilidad: contraseña antigua sin encriptar (texto plano)
            return hashAlmacenado.equals(contrasenaPlano);
        }

        try {
            int iteraciones = Integer.parseInt(partes[0]);
            byte[] sal            = Base64.getDecoder().decode(partes[1]);
            byte[] hashEsperado    = Base64.getDecoder().decode(partes[2]);

            byte[] hashIntento = pbkdf2(contrasenaPlano.toCharArray(), sal, iteraciones, hashEsperado.length * 8);

            return compararEnTiempoConstante(hashEsperado, hashIntento);
        } catch (Exception e) {
            return false;
        }
    }

    /** Indica si un valor almacenado ya está encriptado (formato PBKDF2) o sigue en texto plano. */
    public static boolean estaEncriptada(String hashAlmacenado) {
        return hashAlmacenado != null && hashAlmacenado.split(":").length == 3;
    }

    private static byte[] generarSal() {
        SecureRandom random = new SecureRandom();
        byte[] sal = new byte[LONGITUD_SAL];
        random.nextBytes(sal);
        return sal;
    }

    private static byte[] pbkdf2(char[] contrasena, byte[] sal, int iteraciones, int longitudBits)
            throws InvalidKeySpecException, java.security.NoSuchAlgorithmException {
        PBEKeySpec spec = new PBEKeySpec(contrasena, sal, iteraciones, longitudBits);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITMO);
        return factory.generateSecret(spec).getEncoded();
    }

    /** Comparación en tiempo constante para evitar ataques de temporización. */
    private static boolean compararEnTiempoConstante(byte[] a, byte[] b) {
        if (a.length != b.length) return false;
        int resultado = 0;
        for (int i = 0; i < a.length; i++) {
            resultado |= a[i] ^ b[i];
        }
        return resultado == 0;
    }
}