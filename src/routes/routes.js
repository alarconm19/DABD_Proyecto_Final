const express = require('express');
const router = express.Router();
const controller = require('../controllers/controller');

// Routes
router.get('/', (req, res) => {
    res.render('index');
});

// ejemplo
// router.get('/about', controller.getAbout);
router.get('/inscripcion-equipos', controller.getInscripcionEquipos);
// router.get('/inscripcion-jugadores', controller.getInscripcionJugadores);
router.get('/creacion-torneos', controller.getCreacionTorneos);
router.get('/registro-equipos', controller.getRegistroEquipos);

module.exports = router;