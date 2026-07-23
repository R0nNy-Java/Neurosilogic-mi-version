package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.EvaluacionIMC;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.ArrayList;
import java.util.List;

public class EvaluacionIMCDAO {

    public boolean guardar(EvaluacionIMC evaluacion) {
        if (evaluacion == null) return false;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                if (evaluacion.getIdIMC() == null) {
                    em.persist(evaluacion);
                } else {
                    em.merge(evaluacion);
                }
                tx.commit();
                return true;
            } catch (Exception e) {
                if (tx != null && tx.isActive()) tx.rollback();
                e.printStackTrace();
            } finally {
                em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<EvaluacionIMC> obtenerPorPaciente(Long idPaciente) {
        if (idPaciente == null) return new ArrayList<>();
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                return em.createQuery(
                                "SELECT e FROM EvaluacionIMC e WHERE e.paciente.idPaciente = :idPaciente ORDER BY e.fechaRegistro DESC", EvaluacionIMC.class)
                        .setParameter("idPaciente", idPaciente)
                        .getResultList();
            } finally {
                em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }
}