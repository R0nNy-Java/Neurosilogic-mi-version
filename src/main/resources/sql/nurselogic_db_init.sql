-- ============================================================
-- NURSELOGIC DB - SCRIPT DE INICIALIZACIÓN COMPLETO DE BASE DE DATOS
-- Sistema de Gestión Clínica de Enfermería (ITSCO)
-- ============================================================

CREATE DATABASE IF NOT EXISTS nurselogic_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE nurselogic_db;

-- 1. Tabla: usuario
CREATE TABLE IF NOT EXISTS paciente (
    IdPaciente INT AUTO_INCREMENT PRIMARY KEY,
    Cedula VARCHAR(10) NOT NULL UNIQUE,
    Nombres VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    Edad INT NOT NULL,
    Sexo CHAR(1) NOT NULL, -- 'M' o 'F'
    Estado CHAR(1) DEFAULT 'A'
    );
--tabla enfermedad
CREATE TABLE IF NOT EXISTS enfermedad (
                                          IdEnfermedad     INT AUTO_INCREMENT PRIMARY KEY,
                                          NombreEnfermedad VARCHAR(150) NOT NULL UNIQUE,
    Categoria        VARCHAR(50),
    Descripcion      TEXT
    );
--datos de enfermedad
INSERT INTO enfermedad (NombreEnfermedad, Categoria) VALUES
                                                         ('Diabetes Mellitus Tipo 2', 'METABOLICA'),
                                                         ('Hipertensión Arterial Sistemica', 'CARDIOVASCULAR'),
                                                         ('Asma Bronquial', 'RESPIRATORIA'),
                                                         ('Epilepsia / Trastornos Convulsivos', 'NEUROLOGICA'),
                                                         ('Insuficiencia Renal Cronica', 'RENAL'),
                                                         ('Gastritis Cronica / Ulcera Peptica', 'DIGESTIVA')
    ON DUPLICATE KEY UPDATE IdEnfermedad=IdEnfermedad;

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
    UnidadResultado VARCHAR(255),
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
                                           IdAntecedente        INT AUTO_INCREMENT PRIMARY KEY,
                                           IdPaciente           INT NOT NULL,
                                           IdEnfermedad         INT NULL,
                                           Alergias             VARCHAR(255),                    -- Alergias conocidas
    MedicamentosActuales VARCHAR(255),                    -- Medicamentos de uso habitual
    Observacion          TEXT,                            -- Observaciones/detalles
    FechaRegistro        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IdPaciente)   REFERENCES paciente(IdPaciente),
    FOREIGN KEY (IdEnfermedad) REFERENCES enfermedad(IdEnfermedad)
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
    FechaHora DATETIME,
    RespuestaOcular INT,
    RespuestaVerbal INT,
    RespuestaMotora INT,
    PuntajeTotal INT,
    NivelSeveridad VARCHAR(20),
    Observacion VARCHAR(500),
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente)
);

CREATE TABLE IF NOT EXISTS alerta_clinica (
                                              IdAlerta       INT AUTO_INCREMENT PRIMARY KEY,
                                              Modulo         VARCHAR(50) NOT NULL,                 -- IMC, SIGNOS_VITALES, GLASGOW
    NivelAlerta    VARCHAR(50) NOT NULL,                 -- BAJO_PESO, NORMAL, SOBREPESO, OBESIDAD
    MensajeAlerta  VARCHAR(255) NOT NULL,
    ColorCodigo    VARCHAR(20) DEFAULT 'secondary'        -- success, warning, danger, info
    );
-- ============================================================
-- TABLA: evaluacionimc (Evaluaciones IMC por Paciente)
-- ============================================================
CREATE TABLE IF NOT EXISTS evaluacionimc (
                                             IdIMC          INT AUTO_INCREMENT PRIMARY KEY,
                                             IdPaciente     INT NOT NULL,
                                             Peso           DECIMAL(5,2) NOT NULL,
    Estatura       DECIMAL(4,2) NOT NULL,
    ValorIMC       DECIMAL(4,2) NOT NULL,
    Clasificacion  VARCHAR(50),
    IdAlerta       INT NULL,
    FechaRegistro  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (IdPaciente) REFERENCES paciente(IdPaciente),
    FOREIGN KEY (IdAlerta)   REFERENCES alerta_clinica(IdAlerta)
    );


-- ============================================================
-- 12. TABLA: cierre_ficha
--     Relación Paciente - Enfermero con snapshot consolidado al cerrar ficha
-- ============================================================
CREATE TABLE IF NOT EXISTS cierre_ficha (
                                            IdCierre             INT AUTO_INCREMENT PRIMARY KEY,
                                            IdPaciente           INT NOT NULL,
                                            IdEnfermero          INT NULL,
                                            NombreEnfermero      VARCHAR(150),
    FechaCierre          DATETIME DEFAULT CURRENT_TIMESTAMP,
    UltimosSignosVitales VARCHAR(500),
    UltimoGlasgow        VARCHAR(500),
    UltimoIMC            VARCHAR(500),
    UltimosAntecedentes  VARCHAR(500),
    UltimaDosis          VARCHAR(500),
    FOREIGN KEY (IdPaciente)  REFERENCES paciente(IdPaciente),
    FOREIGN KEY (IdEnfermero) REFERENCES usuario(IdUsuario)
    );
-- Columna Email para la tabla usuario (creada automáticamente por Hibernate,
-- se agrega aquí por si el script se corre contra una BD ya existente)
ALTER TABLE usuario ADD COLUMN IF NOT EXISTS Email VARCHAR(100) AFTER Rol;

-- ── DATOS DE SEMILLA INICIALES ──
-- NOTA: Las contraseñas ya están encriptadas con PBKDF2-SHA256 (ver PasswordUtil.java).
-- Contraseñas en texto plano equivalentes (solo para referencia del desarrollador):
--   admin       -> Admin1234
--   enfermero1  -> Nurse1234
--   enfermero2  -> Nurse5678
INSERT INTO usuario (NombreUsuario, ContrasenaHash, Nombres, Apellidos, Rol, Email, Estado)
VALUES
    ('admin', '65536:Z8x/kiPeqRuF0E4OA0efQw==:Hk3jHdmLXmH/IQRFW4qF8VFMVct/1uItTlbFVy0d2yQ=', 'Administrador', 'del Sistema', 'ADMINISTRADOR', 'admin@nurselogic.ec', 'A'),
    ('enfermero1', '65536:+kurBDs4AUqNIpkIue51uQ==:sr+poUXXmByED80h7ctGbL50t4olxF0fcrcIqtOWJZU=', 'María Fernanda', 'López', 'ENFERMERO', 'mlopez@nurselogic.ec', 'A'),
    ('enfermero2', '65536:ugPtp68A1Jf3jVK1cohGuA==:PuFY/zHvJQeOP7S3c1/f6jOu3qJv1xHeeghl836iaeg=', 'Carlos Eduardo', 'Vega', 'ENFERMERO', 'cvega@nurselogic.ec', 'A')
    ON DUPLICATE KEY UPDATE Email = VALUES(Email);