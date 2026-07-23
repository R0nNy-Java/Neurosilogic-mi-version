package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.AdministracionMedicamento;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class AdministracionMedicamentoDAO {

    private static final List<AdministracionMedicamento> ALMACEN_FALLBACK = new ArrayList<>();

    public boolean guardar(AdministracionMedicamento registro) {
        if (registro == null) return false;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                if (registro.getIdAdministracion() == null) {
                    em.persist(registro);
                } else {
                    em.merge(registro);
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

        registro.setIdAdministracion((long) (ALMACEN_FALLBACK.size() + 1));
        ALMACEN_FALLBACK.add(registro);
        return true;
    }

    public List<AdministracionMedicamento> obtenerPorPaciente(Long idPaciente) {
        if (idPaciente == null) return new ArrayList<>();
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<AdministracionMedicamento> lista = em.createQuery(
                                "SELECT a FROM AdministracionMedicamento a WHERE a.paciente.idPaciente = :idPaciente ORDER BY a.horaAdministracion DESC", AdministracionMedicamento.class)
                        .setParameter("idPaciente", idPaciente)
                        .getResultList();
                if (lista != null) {
                    return lista;
                }
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción consultando administraciones de medicamentos en MySQL: " + e.getMessage());
        }

        return ALMACEN_FALLBACK.stream()
                .filter(a -> a.getPaciente() != null && idPaciente.equals(a.getPaciente().getIdPaciente()))
                .collect(Collectors.toList());
    }
}
