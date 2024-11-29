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
        VALUES (${categoriaInt}, ${divisionInt}, '${fechaInicio}', '${fechaFin}', '${inicioInscripcion}', '${finInscripcion}', '${nombreTorneo}');
    `;

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
    const query = `
        UPDATE Equipo set IdTorneo = ${torneoInt} WHERE NumEquipo = ${equipoInt};
    `;

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
                return res.render('inscripcion-equipos', { title: 'Inscripción de Equipos', error: 'El equipo no pertenece a la misma categoría y división del torneo.',
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


module.exports = {
    // functions
    getCreacionTorneos,
    postCreacionTorneos,
    getInscripcionEquipos,
    postInscripcionEquipos,
    getRegistroEquipos,

};