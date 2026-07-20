package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.Medicamento;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;

public class MedicamentoDAO {

    public void guardar(Medicamento medicamento) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (medicamento.getIdMedicamento() == null) {
                em.persist(medicamento);
            } else {
                em.merge(medicamento);
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

    public void actualizar(Medicamento medicamento) {
        guardar(medicamento);
    }

    public void eliminar(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Medicamento m = em.find(Medicamento.class, id);
            if (m != null) {
                em.remove(m);
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

    public Medicamento buscarPorId(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Medicamento.class, id);
        } finally {
            em.close();
        }
    }

    public List<Medicamento> listarTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT m FROM Medicamento m ORDER BY m.nombreMedicamento ASC", Medicamento.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
