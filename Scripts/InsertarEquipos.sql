--Insertar equipos de prueba.
EXEC InsertarEquipo @NumDivision = 1, @NumCategoria = 1, @Nombre = 'Tigres';
EXEC InsertarEquipo @NumDivision = 1, @NumCategoria = 1, @Nombre = 'Barones de la Plata';
EXEC InsertarEquipo @NumDivision = 1, @NumCategoria = 1, @Nombre = 'San Fernando';
EXEC InsertarEquipo @NumDivision = 1, @NumCategoria = 1, @Nombre = 'Resistencia Jrs.';

--Crear directores tecnicos, asignandolos a un equipo y no haciendolo.
EXEC CrearDirectorTecnico @Nombre = 'Carlos Pérez', @NumEquipo = 1;
EXEC CrearDirectorTecnico @Nombre = 'Juan Martínez', @NumEquipo = 0;
EXEC CrearDirectorTecnico @Nombre = 'Martín Bellavista', @NumEquipo = 0;
EXEC CrearDirectorTecnico @Nombre = 'Marcelo Gallardo', @NumEquipo = 4;

--Asignar directores tecnicos sin equipo.
EXEC AsignarDirectorTecnicoAEquipo @NumDT = 2, @NumEquipo = 2;
EXEC AsignarDirectorTecnicoAEquipo @NumDT = 3, @NumEquipo = 3;
