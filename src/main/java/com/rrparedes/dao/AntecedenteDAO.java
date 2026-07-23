package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.Antecedente;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class AntecedenteDAO {

    private static final List<Antecedente> ALMACEN_ANTECEDENTES_FALLBACK = new ArrayList<>();

    public boolean guardar(Antecedente antecedente) {
        if (antecedente == null) return false;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                if (antecedente.getIdAntecedente() == null) {
                    em.persist(antecedente);
                } else {
                    em.merge(antecedente);
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

        // Fallback local en memoria
        antecedente.setIdAntecedente((long) (ALMACEN_ANTECEDENTES_FALLBACK.size() + 1));
        ALMACEN_ANTECEDENTES_FALLBACK.add(antecedente);
        return true;
    }

    public List<Antecedente> obtenerPorPaciente(Long idPaciente) {
        if (idPaciente == null) return new ArrayList<>();
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<Antecedente> lista = em.createQuery(
                                "SELECT a FROM Antecedente a WHERE a.paciente.idPaciente = :idPaciente ORDER BY a.fechaRegistro DESC", Antecedente.class)
                        .setParameter("idPaciente", idPaciente)
                        .getResultList();
                if (lista != null) {
                    return lista;
                }
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción al consultar antecedentes en MySQL: " + e.getMessage());
        }

        return ALMACEN_ANTECEDENTES_FALLBACK.stream()
                .filter(a -> a.getPaciente() != null && idPaciente.equals(a.getPaciente().getIdPaciente()))
                .collect(Collectors.toList());
    }
}
