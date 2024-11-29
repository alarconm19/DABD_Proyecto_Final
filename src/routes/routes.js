const express = require('express');
const router = express.Router();
const controller = require('../controllers/controller');

// Routes
router.get('/', (req, res) => {
    res.render('index');
});

// ejemplo
// router.get('/about', controller.getAbout);
router.get('/creacion-torneos', controller.getCreacionTorneos);
router.post('/creacion-torneos', controller.postCreacionTorneos);

router.get('/inscripcion-equipos', controller.getInscripcionEquipos);
router.post('/inscripcion-equipos', controller.postInscripcionEquipos);

router.get('/registro-equipos', controller.getRegistroEquipos);
router.post('/registro-equipos', controller.postRegistroEquipos);

module.exports = router;