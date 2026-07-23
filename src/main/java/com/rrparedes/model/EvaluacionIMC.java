package com.rrparedes.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "evaluacionimc")
public class EvaluacionIMC implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IdIMC")
    private Long idIMC;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IdPaciente", nullable = false)
    private Paciente paciente;

    @Column(name = "Peso", nullable = false)
    private Double peso;

    @Column(name = "Estatura", nullable = false)
    private Double estatura;

    @Column(name = "ValorIMC", nullable = false)
    private Double valorIMC;

    @Column(name = "Clasificacion", length = 50)
    private String clasificacion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "IdAlerta")
    private AlertaClinica alerta;

    @Column(name = "FechaRegistro")
    private LocalDateTime fechaRegistro;

    public EvaluacionIMC() {
        this.fechaRegistro = LocalDateTime.now();
    }

    public EvaluacionIMC(Paciente paciente, Double peso, Double estatura, Double valorIMC, String clasificacion, AlertaClinica alerta) {
        this.paciente = paciente;
        this.peso = peso;
        this.estatura = estatura;
        this.valorIMC = valorIMC;
        this.clasificacion = clasificacion;
        this.alerta = alerta;
        this.fechaRegistro = LocalDateTime.now();
    }

    public Long getIdIMC() {
        return idIMC;
    }

    public void setIdIMC(Long idIMC) {
        this.idIMC = idIMC;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public Double getPeso() {
        return peso;
    }

    public void setPeso(Double peso) {
        this.peso = peso;
    }

    public Double getEstatura() {
        return estatura;
    }

    public void setEstatura(Double estatura) {
        this.estatura = estatura;
    }

    public Double getValorIMC() {
        return valorIMC;
    }

    public void setValorIMC(Double valorIMC) {
        this.valorIMC = valorIMC;
    }

    public String getClasificacion() {
        return clasificacion;
    }

    public void setClasificacion(String clasificacion) {
        this.clasificacion = clasificacion;
    }

    public AlertaClinica getAlerta() {
        return alerta;
    }

    public void setAlerta(AlertaClinica alerta) {
        this.alerta = alerta;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}
