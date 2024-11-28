CREATE TABLE Arbitro (
    DNI INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    isCertificado BIT NOT NULL,
    Direccion VARCHAR(100),
    NivelDeExp VARCHAR(50),
    FechaDeNac DATE
);

CREATE TABLE Cancha (
    IDCancha INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(50),
    Direccion VARCHAR(100)
);

CREATE TABLE Jugador (
    NroSocio INT PRIMARY KEY IDENTITY(1, 1),
    NumEquipo INT,
    NumCategoria INT,
    DNI INT,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Direccion VARCHAR(100),
    URLFotoPerf VARCHAR(255),
    FechaNac DATE,
    Telefono VARCHAR(15),
);

CREATE TABLE Partido (
    IDPartido INT PRIMARY KEY IDENTITY(1, 1),
    IDVisitante INT,
    IDLocal INT,
    Arbitro_DNI INT,
    IDCancha INT,
    IDFecha INT,
    Fecha DATE,
    Hora TIME,
);

CREATE TABLE Equipo (
    NumEquipo INT PRIMARY KEY IDENTITY(1, 1),
    NumDivision INT,
    NumCategoria INT,
    IDTorneo INT,
    Nombre VARCHAR(50),
);

CREATE TABLE Categoria (
    NumCategoria INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(50),
    EdadMaxima INT,
    EdadMinima INT
);

CREATE TABLE Division (
    NumDivision INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(50)
);

CREATE TABLE Torneo (
    IDTorneo INT PRIMARY KEY IDENTITY(1, 1),
    NumCategoria INT,
    NumDivision INT,
    FechaInicioTorneo DATE,
    FechaFinTorneo DATE,
    FechaInicioInscripcion DATE,
    FechaFinInscripcion DATE,
    Nombre VARCHAR(50),
);

CREATE TABLE Infraction (
    IDPartido INT,
    NroSocio INT,
    Minuto INT,
    Tipo VARCHAR(50),
    PRIMARY KEY (IDPartido, NroSocio),
);

CREATE TABLE Gol (
    IDPartido INT,
    NroSocio INT,
    Minuto INT,
    PRIMARY KEY (IDPartido, NroSocio),
);

CREATE TABLE Fecha (
    IDFecha INT PRIMARY KEY IDENTITY(1, 1),
    IDRueda INT,
    NroFecha INT,
    FechaInicio DATE,
    FechaFin DATE,
);

CREATE TABLE Rueda (
    IDRueda INT PRIMARY KEY IDENTITY(1, 1),
    NroRueda INT
);

CREATE TABLE Jugador_Participa_Partido (
    IDPartido INT,
    NroSocio INT,
    PRIMARY KEY (IDPartido, NroSocio),
);

CREATE TABLE Fixture (
    IDFixture INT PRIMARY KEY IDENTITY(1, 1),
    IDRueda INT,
    IDTorneo INT,
);

CREATE TABLE DirectorTecnico (
    NumDT INT PRIMARY KEY IDENTITY(1, 1),
    NumEquipo INT,
    Nombre VARCHAR(50),
);