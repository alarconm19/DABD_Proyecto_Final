//controllers

function getCreacionTorneos(req, res) {

    res.render('creacion-torneos', { title: 'Creacion de Torneos' });

}

function postCreacionTorneos(req, res) {
    const { nombreTorneo, categoria, division, fechaInicio, fechaFin, inicioInscripcion, finInscripcion } = req.body;

    // Asegúrate de convertir 'categoria' y 'division' a enteros
    const categoriaInt = parseInt(categoria, 10);
    const divisionInt = parseInt(division, 10);

    // Prepara la consulta SQL con parámetros
    const query = `
        INSERT INTO Torneo (NumCategoria, NumDivision, FechaInicioTorneo, FechaFinTorneo, FechaInicioInscripcion, FechaFinInscripcion, Nombre)
        VALUES (${categoriaInt}, ${divisionInt}, '${fechaInicio}', '${fechaFin}', '${inicioInscripcion}', '${finInscripcion}', '${nombreTorneo}');`;

    // Ejecuta la consulta con parámetros usando req.query
    req.conn.query(query, (err, rows) => {
        if (err) {
            console.error(err);
            return res.render('creacion-torneos', { title: 'Creación de Torneos', error: 'Error al crear torneo' });
        }

        res.render('creacion-torneos', { title: 'Creación de Torneos', success: 'Creación exitosa' });
    });
}

function getInscripcionEquipos(req, res) {
    req.conn.query('SELECT IdTorneo, Nombre, NumCategoria, NumDivision FROM Torneo', (err, torneos) => {
        if (err) {
            res.send(err);
        }

        req.conn.query('SELECT NumEquipo, Nombre, NumDivision, NumCategoria from Equipo WHERE IdTorneo is null', (err, equipos) => {
            if (err) {
                res.send(err);
            }

            res.render('inscripcion-equipos', { title: 'Creacion de Torneos', torneos: torneos.recordset, equipos: equipos.recordset });
        });
    });
}

function postInscripcionEquipos(req, res) {
    const { torneo, equipo } = req.body;

    console.log(torneo, equipo);
    // Asegúrate de convertir 'torneo' y 'equipo' a enteros
    const torneoInt = parseInt(torneo, 10);
    const equipoInt = parseInt(equipo, 10);

    console.log(torneoInt, equipoInt);

    // Prepara la consulta SQL para insertar
    const query = `UPDATE Equipo set IdTorneo = ${torneoInt} WHERE NumEquipo = ${equipoInt};`;

    // Consulta torneos
    req.conn.query('SELECT idtorneo, NumCategoria, NumDivision FROM Torneo', (err, torneos) => {
        if (err) {
            return res.send(err);
        }

        // Consulta equipos
        req.conn.query('SELECT NumEquipo, NumCategoria, NumDivision FROM Equipo', (err, equipos) => {
            if (err) {
                return res.send(err);
            }

            // Encuentra el torneo correspondiente
            const torneoSeleccionado = torneos.recordset.find(t => t.idtorneo === torneoInt);

            // Encuentra el equipo correspondiente
            const equipoSeleccionado = equipos.recordset.find(e => e.NumEquipo === equipoInt);

            // Verifica si las categorías y divisiones coinciden
            if (!torneoSeleccionado || !equipoSeleccionado ||
                torneoSeleccionado.NumCategoria !== equipoSeleccionado.NumCategoria ||
                torneoSeleccionado.NumDivision !== equipoSeleccionado.NumDivision) {
                return res.render('inscripcion-equipos', {
                    title: 'Inscripción de Equipos', error: 'El equipo no pertenece a la misma categoría y división del torneo.',
                    torneos: torneos.recordset, equipos: equipos.recordset
                });
            }

            // Si coinciden, inserta el equipo
            req.conn.query(query, (err, rows) => {
                if (err) {
                    console.error(err);
                    return res.render('inscripcion-equipos', {
                        title: 'Inscripción de Equipos',
                        error: 'Error al inscribir equipo',
                        torneos: torneos.recordset,
                        equipos: equipos.recordset
                    });
                }

                res.render('inscripcion-equipos', {
                    title: 'Inscripción de Equipos',
                    success: 'Inscripción exitosa',
                    torneos: torneos.recordset,
                    equipos: equipos.recordset
                });
            });
        });
    });
}

function getRegistroEquipos(req, res) {
    res.render('registro-equipos', { title: 'Registro de Equipos' });
}

function postRegistroEquipos(req, res) {
    const { nombreEquipo, categoria, division, nombreDT } = req.body;

    const categoriaInt = parseInt(categoria, 10);
    const divisionInt = parseInt(division, 10);

    if (isNaN(categoriaInt) || isNaN(divisionInt)) {
        return res.render('registro-equipos', { title: 'Registro de Equipos', error: 'Categoría o división no válida.' });
    }

    // Crear el equipo
    const queryCrearEquipo = `EXEC InsertarEquipo @NumDivision = ${divisionInt}, @NumCategoria = ${categoriaInt}, @Nombre = '${nombreEquipo}';`;
    req.conn.query(queryCrearEquipo, (err) => {
        if (err) {
            console.error(err);
            return res.render('registro-equipos', { title: 'Registro de Equipos', error: 'Error al registrar equipo.' });
        }

        // Obtener el número de equipo
        req.conn.query('SELECT MAX(NumEquipo) as NumEquipo FROM Equipo', (err, rows) => {
            if (err) {
                console.error(err);
                return res.render('registro-equipos', { title: 'Registro de Equipos', error: 'Error al obtener número de equipo.' });
            }

            const NumEquipo = parseInt(rows.recordset[0].NumEquipo, 10);
            if (isNaN(NumEquipo)) {
                return res.render('registro-equipos', { title: 'Registro de Equipos', error: 'Número de equipo inválido.' });
            }

            // Crear el técnico
            const queryCrearTecnico = `EXEC CrearDirectorTecnico @Nombre = '${nombreDT}', @NumEquipo = ${NumEquipo};`;
            req.conn.query(queryCrearTecnico, (err) => {
                if (err) {
                    console.error(err);
                    return res.render('registro-equipos', { title: 'Registro de Equipos', error: 'Error al registrar técnico.' });
                }

                res.render('registro-equipos', { title: 'Registro de Equipos', success: 'Registro exitoso.' });
            });
        });
    });
}


function getRegistroJugador(req, res) {
    res.render('registro-jugador', { title: 'Registro de Jugadores' });
}

function postRegistroJugador(req, res) {
    
    const { dni, nombre, apellido, direccion, fechaNacimiento, telefono } = req.body;

    // Convierte los valores necesarios a enteros
    const dniInt = parseInt(dni, 10);
    const numEquipo = 1;

    console.log(req.body);
    // Prepara la consulta SQL con parámetros
    const query = `
        EXEC InsertarJugador 
        @DNI = ${dniInt}, 
        @Nombre = '${nombre}', 
        @Apellido = '${apellido}', 
        @Direccion = '${direccion}', 
        @FechaNac = '${fechaNacimiento}',
        @URLFotoPerf = 'asd', 
        @Telefono = '${telefono}',
        @NumEquipo = ${numEquipo};
    `;

    //console.log(query); // Esto imprimirá la consulta antes de ejecutarla
     // Ejecuta la consulta
    req.conn.query(query, (err, rows) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err.message);
            return res.render('registro-jugador', { 
                title: 'Registro de Jugadores', 
                error: 'Hubo un error al intentar registrar el jugador. Por favor, inténtalo nuevamente.' 
            });
        }

        console.log('Datos insertados:', rows); // Esto te ayudará a ver el resultado
        res.render('registro-jugador', { 
            title: 'Registro de Jugadores', 
            success: 'Jugador registrado exitosamente.' 
        });
    });
}

function getInscripcionJugador(req, res) {
    res.render('inscripcion-jugador', { title: 'Asignar jugadores' });
}

function postInscripcionJugador(req, res) {
    const { jugador, equipo } = req.body; // Extraer datos del formulario

    if (!jugador || !equipo) {
        return res.status(400).send('Por favor, complete todos los campos.');
    }

    try {
        // Insertar en la base de datos
        req.conn
            .input('jugadorId', sql.Int, jugador)
            .input('equipoId', sql.Int, equipo)
            .query(`
                INSERT INTO JugadorEquipo (JugadorId, EquipoId)
                VALUES (@jugadorId, @equipoId)
            `);

        res.send('Jugador asignado exitosamente.');
    } catch (error) {
        console.error('Error al asignar jugador:', error);
        res.status(500).send('Ocurrió un error al asignar el jugador.');
    }
}

module.exports = {
    // functions
    getCreacionTorneos,
    postCreacionTorneos,
    getInscripcionEquipos,
    postInscripcionEquipos,
    getRegistroEquipos,
    postRegistroEquipos,
    getRegistroJugador,
    postRegistroJugador,
    getInscripcionJugador,
    postInscripcionJugador
};