package com.rrparedes.dao;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.model.AlertaClinica;
import jakarta.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

public class AlertaClinicaDAO {

    public AlertaClinica obtenerAlertaIMC(double imc) {
        String nivel;
        if (imc < 18.5) {
            nivel = "BAJO_PESO";
        } else if (imc < 25.0) {
            nivel = "NORMAL";
        } else if (imc < 30.0) {
            nivel = "SOBREPESO";
        } else {
            nivel = "OBESIDAD";
        }

        try {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                List<AlertaClinica> lista = em.createQuery(
                                "SELECT a FROM AlertaClinica a WHERE a.modulo = 'IMC' AND a.nivelAlerta = :niv", AlertaClinica.class)
                        .setParameter("niv", nivel)
                        .getResultList();
                if (lista != null && !lista.isEmpty()) {
                    return lista.get(0);
                }
            } finally {
                em.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}