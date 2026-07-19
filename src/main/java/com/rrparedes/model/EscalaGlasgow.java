package com.rrparedes.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "escalaglasgow")
public class EscalaGlasgow implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IdGlasgow")
    private Long idGlasgow;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IdPaciente", nullable = false)
    private Paciente paciente;

    @Column(name = "FechaHora")
    private LocalDateTime fechaHora;

    @Column(name = "RespuestaOcular")
    private Integer respuestaOcular;

    @Column(name = "RespuestaVerbal")
    private Integer respuestaVerbal;

    @Column(name = "RespuestaMotora")
    private Integer respuestaMotora;

    @Column(name = "PuntajeTotal")
    private Integer puntajeTotal;

    public EscalaGlasgow() {
    }

    public EscalaGlasgow(Paciente paciente, LocalDateTime fechaHora, Integer respuestaOcular, Integer respuestaVerbal, Integer respuestaMotora, Integer puntajeTotal) {
        this.paciente = paciente;
        this.fechaHora = fechaHora;
        this.respuestaOcular = respuestaOcular;
        this.respuestaVerbal = respuestaVerbal;
        this.respuestaMotora = respuestaMotora;
        this.puntajeTotal = puntajeTotal;
    }

    public Long getIdGlasgow() {
        return idGlasgow;
    }

    public void setIdGlasgow(Long idGlasgow) {
        this.idGlasgow = idGlasgow;
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

    public Integer getRespuestaOcular() {
        return respuestaOcular;
    }

    public void setRespuestaOcular(Integer respuestaOcular) {
        this.respuestaOcular = respuestaOcular;
    }

    public Integer getRespuestaVerbal() {
        return respuestaVerbal;
    }

    public void setRespuestaVerbal(Integer respuestaVerbal) {
        this.respuestaVerbal = respuestaVerbal;
    }

    public Integer getRespuestaMotora() {
        return respuestaMotora;
    }

    public void setRespuestaMotora(Integer respuestaMotora) {
        this.respuestaMotora = respuestaMotora;
    }

    public Integer getPuntajeTotal() {
        return puntajeTotal;
    }

    public void setPuntajeTotal(Integer puntajeTotal) {
        this.puntajeTotal = puntajeTotal;
    }
}
