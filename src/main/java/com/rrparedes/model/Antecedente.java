package com.rrparedes.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "antecedente")
public class Antecedente implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IdAntecedente")
    private Long idAntecedente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IdPaciente", nullable = false)
    private Paciente paciente;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "IdEnfermedad")
    private Enfermedad enfermedadObj;

    @Column(name = "Alergias", length = 255)
    private String alergias;

    @Column(name = "MedicamentosActuales", length = 255)
    private String medicamentosActuales;

    @Column(name = "Observacion", columnDefinition = "TEXT")
    private String observacion;

    @Column(name = "FechaRegistro")
    private LocalDateTime fechaRegistro;

    public Antecedente() {
        this.fechaRegistro = LocalDateTime.now();
    }

    public Antecedente(Paciente paciente, Enfermedad enfermedadObj, String alergias, String medicamentosActuales, String observacion) {
        this.paciente = paciente;
        this.enfermedadObj = enfermedadObj;
        this.alergias = alergias;
        this.medicamentosActuales = medicamentosActuales;
        this.observacion = observacion;
        this.fechaRegistro = LocalDateTime.now();
    }

    public Long getIdAntecedente() {
        return idAntecedente;
    }

    public void setIdAntecedente(Long idAntecedente) {
        this.idAntecedente = idAntecedente;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public Enfermedad getEnfermedadObj() {
        return enfermedadObj;
    }

    public void setEnfermedadObj(Enfermedad enfermedadObj) {
        this.enfermedadObj = enfermedadObj;
    }

    public String getNombreEnfermedad() {
        return enfermedadObj != null ? enfermedadObj.getNombreEnfermedad() : "Ninguna / No especificada";
    }

    public String getAlergias() {
        return alergias != null ? alergias : "Ninguna";
    }

    public void setAlergias(String alergias) {
        this.alergias = alergias;
    }

    public String getMedicamentosActuales() {
        return medicamentosActuales != null ? medicamentosActuales : "Ninguno";
    }

    public void setMedicamentosActuales(String medicamentosActuales) {
        this.medicamentosActuales = medicamentosActuales;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}
