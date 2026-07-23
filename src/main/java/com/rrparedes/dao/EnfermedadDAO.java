package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.Enfermedad;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.ArrayList;
import java.util.List;

public class EnfermedadDAO {

    private static final List<Enfermedad> CATALOGO_ENFERMEDADES_FALLBACK = new ArrayList<>();

    static {
        CATALOGO_ENFERMEDADES_FALLBACK.add(new Enfermedad(1L, "Hipertensión Arterial (HTA)", "Cardiovascular", "Presión arterial elevada."));
        CATALOGO_ENFERMEDADES_FALLBACK.add(new Enfermedad(2L, "Diabetes Mellitus Tipo 2", "Metabólica", "Control inadecuado de glucemia."));
        CATALOGO_ENFERMEDADES_FALLBACK.add(new Enfermedad(3L, "Asma Bronquial", "Respiratoria", "Enfermedad inflamatoria de vías respiratorias."));
        CATALOGO_ENFERMEDADES_FALLBACK.add(new Enfermedad(4L, "Insuficiencia Renal Crónica", "Renal", "Deterioro de la función renal."));
        CATALOGO_ENFERMEDADES_FALLBACK.add(new Enfermedad(5L, "Epilepsia / Convulsiones", "Neurológica", "Trastorno neurológico recurrente."));
        CATALOGO_ENFERMEDADES_FALLBACK.add(new Enfermedad(6L, "Ninguna / Control de rutina", "General", "Sin patología previa identificada."));
    }

    public List<Enfermedad> listarTodas() {
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<Enfermedad> lista = em.createQuery("SELECT e FROM Enfermedad e ORDER BY e.idEnfermedad ASC", Enfermedad.class).getResultList();
                if (lista != null && !lista.isEmpty()) {
                    return lista;
                }
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Error listando enfermedades desde MySQL: " + e.getMessage());
        }
        return new ArrayList<>(CATALOGO_ENFERMEDADES_FALLBACK);
    }

    public Enfermedad buscarPorId(Long id) {
        if (id == null) return null;
        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                Enfermedad e = em.find(Enfermedad.class, id);
                if (e != null) return e;
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Notice: Error buscando enfermedad por ID en MySQL: " + e.getMessage());
        }
        return CATALOGO_ENFERMEDADES_FALLBACK.stream()
                .filter(e -> e.getIdEnfermedad().equals(id))
                .findFirst()
                .orElse(null);
    }

    public void guardar(Enfermedad enfermedad) {
        if (enfermedad == null) return;
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (enfermedad.getIdEnfermedad() == null) {
                em.persist(enfermedad);
            } else {
                em.merge(enfermedad);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
