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
            if (tx.isActive()) {
                tx.rollback();
            }
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
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Paciente> resultados = em.createQuery(
                "SELECT p FROM Paciente p WHERE p.cedula = :cedula", Paciente.class)
                .setParameter("cedula", cedula)
                .getResultList();
            return resultados.isEmpty() ? null : resultados.get(0);
        } finally {
            em.close();
        }
    }

    public List<Paciente> listarTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Paciente p", Paciente.class).getResultList();
        } finally {
            em.close();
        }
    }
}
