package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.Medicamento;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class MedicamentoDAO {

    public List<Medicamento> listarTodos() {
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<Medicamento> lista = em.createQuery("SELECT m FROM Medicamento m ORDER BY m.idMedicamento ASC", Medicamento.class).getResultList();
                if (lista != null && !lista.isEmpty()) {
                    return lista;
                }

                // Precarga inicial si la tabla está vacía
                guardar(new Medicamento("Paracetamol Jarabe", new BigDecimal("500.00"), "mg", new BigDecimal("10.00"), "mL", "Paracetamol 500mg / 10mL"));
                guardar(new Medicamento("Amoxicilina Suspensión", new BigDecimal("250.00"), "mg", new BigDecimal("5.00"), "mL", "Amoxicilina 250mg / 5mL"));
                guardar(new Medicamento("Ibuprofeno Jarabe", new BigDecimal("200.00"), "mg", new BigDecimal("5.00"), "mL", "Ibuprofeno 200mg / 5mL"));
                guardar(new Medicamento("Omeprazol Ampolla", new BigDecimal("40.00"), "mg", new BigDecimal("10.00"), "mL", "Omeprazol 40mg / 10mL"));
                guardar(new Medicamento("Ampicilina Inyectable", new BigDecimal("1000.00"), "mg", new BigDecimal("4.00"), "mL", "Ampicilina 1g / 4mL"));

                return em.createQuery("SELECT m FROM Medicamento m ORDER BY m.idMedicamento ASC", Medicamento.class).getResultList();
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción consultando medicamentos en MySQL: " + e.getMessage());
        }
        return new ArrayList<>();
    }

    public Medicamento buscarPorId(Long id) {
        if (id == null) return null;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                return em.find(Medicamento.class, id);
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Excepción buscando medicamento por ID en MySQL: " + e.getMessage());
        }
        return null;
    }

    public boolean guardar(Medicamento medicamento) {
        if (medicamento == null) return false;
        try {
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

    public boolean eliminar(Long id) {
        if (id == null) return false;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                Medicamento med = em.find(Medicamento.class, id);
                if (med != null) {
                    em.remove(med);
                    tx.commit();
                    return true;
                }
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
}
