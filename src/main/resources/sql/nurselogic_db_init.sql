-- ============================================================
-- NURSELOGIC DB - SCRIPT DE INICIALIZACIÓN COMPLETO DE BASE DE DATOS
-- Sistema de Gestión Clínica de Enfermería (ITSCO)
-- ============================================================

CREATE DATABASE IF NOT EXISTS nurselogic_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE nurselogic_db;

-- 1. Tabla: usuario
CREATE TABLE IF NOT EXISTS usuario (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(30) NOT NULL UNIQUE,
    ContrasenaHash VARCHAR(255) NOT NULL,
    Nombres VARCHAR(50),
    Apellidos VARCHAR(50),
    Rol VARCHAR(20),
    Estado CHAR(1) DEFAULT 'A'
);

-- 2. Tabla: paciente
CREATE TABLE IF NOT EXISTS paciente (
    IdPaciente INT AUTO_INCREMENT PRIMARY KEY,
    Nombres VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    Cedula VARCHAR(10) NOT NULL UNIQUE,
    Edad INT,
    Sexo CHAR(1),
    SintomasActuales TEXT,
    Alergias TEXT,
    DispositivosMedicos TEXT,
    Estado CHAR(1) DEFAULT 'A'
);

-- 3. Tabla: medicamento
CREATE TABLE IF NOT EXISTS medicamento (
    IdMedicamento INT AUTO_INCREMENT PRIMARY KEY,
    NombreMedicamento VARCHAR(50) NOT NULL,
    Concentracion DECIMAL(10,2),
    UnidadConcentracion VARCHAR(10),
    VolumenPresentacion DECIMAL(10,2),
    UnidadVolumen VARCHAR(10),
    PresentacionCompleta VARCHAR(100)
);

-- 4. Tabla: prescripcionmedica
CREATE TABLE IF NOT EXISTS prescripcionmedica (
    IdPrescripcion INT AUTO_INCREMENT PRIMARY KEY,
    IdPaciente INT NOT NULL,
    IdMedicamento INT NOT NULL,
    DosisPrescrita DECIMAL(10,2),
    UnidadDosis VARCHAR(10),
    FechaPrescripcion DATETIME,
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente),
    FOREIGN KEY (IdMedicamento) REFERENCES medicamento(IdMedicamento)
);

-- 5. Tabla: administracionmedicamento
CREATE TABLE IF NOT EXISTS administracionmedicamento (
    IdAdministracion INT AUTO_INCREMENT PRIMARY KEY,
    IdPrescripcion INT,
    IdPaciente INT NOT NULL,
    DosisCalculada DECIMAL(10,2),
    UnidadResultado VARCHAR(10),
    HoraAdministracion DATETIME,
    IdEnfermero INT,
    FOREIGN KEY (IdPrescripcion) REFERENCES prescripcionmedica(IdPrescripcion),
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente),
    FOREIGN KEY (IdEnfermero) REFERENCES usuario(IdUsuario)
);

-- 6. Tabla: auditoriaacceso
CREATE TABLE IF NOT EXISTS auditoriaacceso (
    IdAuditoria INT AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT,
    IdPaciente INT,
    Accion VARCHAR(50),
    MotivoAnulacion TEXT,
    Timestamp DATETIME,
    FOREIGN KEY (IdUsuario) REFERENCES usuario(IdUsuario),
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente)
);

-- 7. Tabla: antecedente
CREATE TABLE IF NOT EXISTS antecedente (
    IdAntecedente INT AUTO_INCREMENT PRIMARY KEY,
    IdPaciente INT NOT NULL,
    Enfermedad VARCHAR(100),
    FechaRegistro DATETIME,
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente)
);

-- 8. Tabla: signovital
CREATE TABLE IF NOT EXISTS signovital (
    IdSignoVital INT AUTO_INCREMENT PRIMARY KEY,
    IdPaciente INT NOT NULL,
    FechaHora DATETIME(0),
    Temperatura DECIMAL(4,2),
    PresionSistolica INT,
    PresionDiastolica INT,
    FrecuenciaCardiaca INT,
    FrecuenciaRespiratoria INT,
    SaturacionO2 INT,
    Glicemia DECIMAL(5,1),
    AlertaGenerada CHAR(1),
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente)
    );

-- 9. Tabla: escalaglasgow
CREATE TABLE IF NOT EXISTS escalaglasgow (
    IdGlasgow INT AUTO_INCREMENT PRIMARY KEY,
    IdPaciente INT NOT NULL,
    FechaHora DATETIME,
    RespuestaOcular INT,
    RespuestaVerbal INT,
    RespuestaMotora INT,
    PuntajeTotal INT,
    NivelSeveridad VARCHAR(20),
    Observacion VARCHAR(500),
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente)
);

-- ── DATOS DE SEMILLA INICIALES ──
INSERT INTO usuario (NombreUsuario, ContrasenaHash, Nombres, Apellidos, Rol, Estado)
    VALUES
('admin', 'Admin1234', 'Administrador', 'del Sistema', 'ADMINISTRADOR', 'A'),
('enfermero1', 'Nurse1234', 'María Fernanda', 'López', 'ENFERMERO', 'A'),
('enfermero2', 'Nurse5678', 'Carlos Eduardo', 'Vega', 'ENFERMERO', 'A')
ON DUPLICATE KEY UPDATE IdUsuario=IdUsuario;
