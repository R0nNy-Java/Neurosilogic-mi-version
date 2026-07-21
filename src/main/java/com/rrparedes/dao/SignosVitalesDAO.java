package com.rrparedes.dao;
import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.SignoVital;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;

public class SignosVitalesDAO {

    public void guardar(SignoVital registro) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (registro.getIdSignoVital() == null) {
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

    public SignoVital buscarPorId(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(SignoVital.class, id);
        } finally {
            em.close();
        }
    }

    public List<SignoVital> listarPorPaciente(Long idPaciente) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT s FROM SignoVital s WHERE s.paciente.idPaciente = :idPaciente " +
                                    "ORDER BY s.fechaHora DESC", SignoVital.class)
                    .setParameter("idPaciente", idPaciente)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}