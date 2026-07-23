package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.CierreFicha;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.ArrayList;
import java.util.List;

public class CierreFichaDAO {

    private static final List<CierreFicha> ALMACEN_FALLBACK = new ArrayList<>();

    public boolean guardar(CierreFicha cierre) {
        if (cierre == null) return false;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                if (cierre.getIdCierre() == null) {
                    em.persist(cierre);
                } else {
                    em.merge(cierre);
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

        cierre.setIdCierre((long) (ALMACEN_FALLBACK.size() + 1));
        ALMACEN_FALLBACK.add(cierre);
        return true;
    }

    public CierreFicha obtenerUltimoPorPaciente(Long idPaciente) {
        if (idPaciente == null) return null;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<CierreFicha> lista = em.createQuery(
                                "SELECT c FROM CierreFicha c WHERE c.paciente.idPaciente = :idPaciente ORDER BY c.fechaCierre DESC", CierreFicha.class)
                        .setParameter("idPaciente", idPaciente)
                        .setMaxResults(1)
                        .getResultList();
                if (lista != null && !lista.isEmpty()) {
                    return lista.get(0);
                }
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción consultando último cierre de ficha en MySQL: " + e.getMessage());
        }

        return ALMACEN_FALLBACK.stream()
                .filter(c -> c.getPaciente() != null && idPaciente.equals(c.getPaciente().getIdPaciente()))
                .reduce((first, second) -> second)
                .orElse(null);
    }
}
