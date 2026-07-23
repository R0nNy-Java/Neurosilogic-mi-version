package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.Paciente;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;

public class PacienteDAO {

    public void guardar(Paciente paciente) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (paciente.getIdPaciente() == null) {
                em.persist(paciente);
            } else {
                em.merge(paciente);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    public void actualizar(Paciente paciente) {
        guardar(paciente);
    }

    public void eliminar(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Paciente p = em.find(Paciente.class, id);
            if (p != null) {
                em.remove(p);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    public Paciente buscarPorId(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Paciente.class, id);
        } finally {
            em.close();
        }
    }

    public Paciente buscarPorCedula(String cedula) {
        if (cedula == null || cedula.trim().isEmpty()) return null;
        String cLimpia = cedula.trim();
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<Paciente> resultados = em.createQuery(
                                "SELECT p FROM Paciente p WHERE p.cedula = :cedula", Paciente.class)
                        .setParameter("cedula", cLimpia)
                        .getResultList();
                if (resultados != null && !resultados.isEmpty()) {
                    return resultados.get(0);
                }
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción en query JPA por cédula: " + e.getMessage());
        }

        // Fallback robusto iterando la lista completa
        try {
            List<Paciente> todos = listarTodos();
            if (todos != null) {
                for (Paciente p : todos) {
                    if (p.getCedula() != null && cLimpia.equals(p.getCedula().trim())) {
                        return p;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción en fallback listarTodos por cédula: " + e.getMessage());
        }
        return null;
    }

    public List<Paciente> listarTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Paciente p ORDER BY p.apellidos ASC", Paciente.class).getResultList();
        } finally {
            em.close();
        }
    }
}
