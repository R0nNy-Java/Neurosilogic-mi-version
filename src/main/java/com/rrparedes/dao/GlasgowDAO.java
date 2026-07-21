package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.EscalaGlasgow;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;

public class GlasgowDAO {

    public void guardar(EscalaGlasgow registro) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (registro.getIdGlasgow() == null) {
                em.persist(registro);
            } else {
                em.merge(registro);
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

    public EscalaGlasgow buscarPorId(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(EscalaGlasgow.class, id);
        } finally {
            em.close();
        }
    }

    public List<EscalaGlasgow> listarPorPaciente(Long idPaciente) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT g FROM EscalaGlasgow g WHERE g.paciente.idPaciente = :idPaciente " +
                                    "ORDER BY g.fechaHora DESC", EscalaGlasgow.class)
                    .setParameter("idPaciente", idPaciente)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
