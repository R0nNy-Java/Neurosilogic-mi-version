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

    @Column(name = "Enfermedad", length = 50)
    private String enfermedad;

    @Column(name = "FechaRegistro")
    private LocalDateTime fechaRegistro;

    public Antecedente() {
    }

    public Antecedente(Paciente paciente, String enfermedad, LocalDateTime fechaRegistro) {
        this.paciente = paciente;
        this.enfermedad = enfermedad;
        this.fechaRegistro = fechaRegistro;
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

    public String getEnfermedad() {
        return enfermedad;
    }

    public void setEnfermedad(String enfermedad) {
        this.enfermedad = enfermedad;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}
