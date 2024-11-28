//controllers

function getInscripcionEquipos(req, res) {
    res.render('inscripcion-equipos', { title: 'Inscripción de Equipos' });
}

function getCreacionTorneos(req, res) {
    res.render('creacion-torneos', { title: 'Creacion de Torneos' });
}

function getRegistroEquipos(req, res) {
    res.render('registro-equipos', { title: 'Registro de Equipos' });
}


module.exports = {
    // functions
    getInscripcionEquipos,
    getCreacionTorneos,
    getRegistroEquipos,
};