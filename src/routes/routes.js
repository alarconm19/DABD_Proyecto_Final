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

module.exports = router;