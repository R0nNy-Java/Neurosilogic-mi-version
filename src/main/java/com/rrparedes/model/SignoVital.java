package com.rrparedes.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "signovital")
public class SignoVital implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IdSignoVital")
    private Long idSignoVital;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IdPaciente", nullable = false)
    private Paciente paciente;

    @Column(name = "FechaHora")
    private LocalDateTime fechaHora;

    @Column(name = "Temperatura", precision = 4, scale = 2)
    private BigDecimal temperatura;

    @Column(name = "PresionSistolica")
    private Integer presionSistolica;

    @Column(name = "PresionDiastolica")
    private Integer presionDiastolica;

    @Column(name = "FrecuenciaCardiaca")
    private Integer frecuenciaCardiaca;

    @Column(name = "FrecuenciaRespiratoria")
    private Integer frecuenciaRespiratoria;

    @Column(name = "SaturacionO2")
    private Integer saturacionO2;

    @Column(name = "Glicemia", precision = 5, scale = 1)
    private BigDecimal glicemia;

    @Column(name = "AlertaGenerada", length = 1)
    private String alertaGenerada;

    public SignoVital() {
    }

    public SignoVital(Paciente paciente, LocalDateTime fechaHora, BigDecimal temperatura, Integer presionSistolica, Integer presionDiastolica, Integer frecuenciaCardiaca, Integer frecuenciaRespiratoria, Integer saturacionO2, BigDecimal glicemia, String alertaGenerada) {
        this.paciente = paciente;
        this.fechaHora = fechaHora;
        this.temperatura = temperatura;
        this.presionSistolica = presionSistolica;
        this.presionDiastolica = presionDiastolica;
        this.frecuenciaCardiaca = frecuenciaCardiaca;
        this.frecuenciaRespiratoria = frecuenciaRespiratoria;
        this.saturacionO2 = saturacionO2;
        this.glicemia = glicemia;
        this.alertaGenerada = alertaGenerada;
    }

    public Long getIdSignoVital() {
        return idSignoVital;
    }

    public void setIdSignoVital(Long idSignoVital) {
        this.idSignoVital = idSignoVital;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public LocalDateTime getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(LocalDateTime fechaHora) {
        this.fechaHora = fechaHora;
    }

    public BigDecimal getTemperatura() {
        return temperatura;
    }

    public void setTemperatura(BigDecimal temperatura) {
        this.temperatura = temperatura;
    }

    public Integer getPresionSistolica() {
        return presionSistolica;
    }

    public void setPresionSistolica(Integer presionSistolica) {
        this.presionSistolica = presionSistolica;
    }

    public Integer getPresionDiastolica() {
        return presionDiastolica;
    }

    public void setPresionDiastolica(Integer presionDiastolica) {
        this.presionDiastolica = presionDiastolica;
    }

    public Integer getFrecuenciaCardiaca() {
        return frecuenciaCardiaca;
    }

    public void setFrecuenciaCardiaca(Integer frecuenciaCardiaca) {
        this.frecuenciaCardiaca = frecuenciaCardiaca;
    }

    public Integer getFrecuenciaRespiratoria() {
        return frecuenciaRespiratoria;
    }

    public void setFrecuenciaRespiratoria(Integer frecuenciaRespiratoria) {
        this.frecuenciaRespiratoria = frecuenciaRespiratoria;
    }

    public Integer getSaturacionO2() {
        return saturacionO2;
    }

    public void setSaturacionO2(Integer saturacionO2) {
        this.saturacionO2 = saturacionO2;
    }

    public BigDecimal getGlicemia() {
        return glicemia;
    }

    public void setGlicemia(BigDecimal glicemia) {
        this.glicemia = glicemia;
    }

    public String getAlertaGenerada() {
        return alertaGenerada;
    }

    public void setAlertaGenerada(String alertaGenerada) {
        this.alertaGenerada = alertaGenerada;
    }
}
