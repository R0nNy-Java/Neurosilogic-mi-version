package com.rrparedes.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "paciente")
public class Paciente implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IdPaciente")
    private Long idPaciente;

    @Column(name = "Nombres", length = 50, nullable = false)
    private String nombres;

    @Column(name = "Apellidos", length = 50, nullable = false)
    private String apellidos;

    @Column(name = "Cedula", length = 10, nullable = false, unique = true)
    private String cedula;

    @Column(name = "Edad")
    private Integer edad;

    @Column(name = "Sexo", length = 1)
    private String sexo;

    @Column(name = "SintomasActuales", columnDefinition = "TEXT")
    private String sintomasActuales;

    @Column(name = "Alergias", columnDefinition = "TEXT")
    private String alergias;

    @Column(name = "DispositivosMedicos", columnDefinition = "TEXT")
    private String dispositivosMedicos;

    @Column(name = "Estado", length = 1)
    private String estado;

    public Paciente() {
    }

    public Paciente(String nombres, String apellidos, String cedula, Integer edad, String sexo, String sintomasActuales, String alergias, String dispositivosMedicos, String estado) {
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.cedula = cedula;
        this.edad = edad;
        this.sexo = sexo;
        this.sintomasActuales = sintomasActuales;
        this.alergias = alergias;
        this.dispositivosMedicos = dispositivosMedicos;
        this.estado = estado;
    }

    public Long getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(Long idPaciente) {
        this.idPaciente = idPaciente;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getCedula() {
        return cedula;
    }

    public void setCedula(String cedula) {
        this.cedula = cedula;
    }

    public Integer getEdad() {
        return edad;
    }

    public void setEdad(Integer edad) {
        this.edad = edad;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public String getSintomasActuales() {
        return sintomasActuales;
    }

    public void setSintomasActuales(String sintomasActuales) {
        this.sintomasActuales = sintomasActuales;
    }

    public String getAlergias() {
        return alergias;
    }

    public void setAlergias(String alergias) {
        this.alergias = alergias;
    }

    public String getDispositivosMedicos() {
        return dispositivosMedicos;
    }

    public void setDispositivosMedicos(String dispositivosMedicos) {
        this.dispositivosMedicos = dispositivosMedicos;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
