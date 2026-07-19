package com.rrparedes.config;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Listener que inicializa JPA al arrancar la aplicación web.
 * Crea la base de datos / tablas en MySQL automáticamente si no existen (hbm2ddl.auto = update).
 */
@WebListener
public class JPAInitializerListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println(">>> Inicializando JPA / Hibernate para NurseLogic...");
            EntityManager em = JPAUtil.getEntityManager();
            em.close();
            System.out.println(">>> JPA inicializado exitosamente. Tablas sincronizadas en MySQL.");
        } catch (Exception e) {
            System.err.println(">>> Error al inicializar JPA en el arranque: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JPAUtil.shutdown();
        System.out.println(">>> JPA CERRADO.");
    }
}
