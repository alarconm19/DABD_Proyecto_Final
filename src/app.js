const express = require ('express');
const { engine } = require ('express-handlebars');
const session = require ('express-session');
const path = require('path');
const sql = require('mssql');
const routes = require('./routes/routes');
require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 4000;

// Config handlebars
app.set('views', __dirname + '/views');
app.engine('.hbs', engine ({
    extname: '.hbs'
}));
app.set('view engine', '.hbs');

// Config public folder
app.use(express.static(path.join(__dirname, '..', 'public')));

// Crear un pool de conexiones
const localhost = new sql.ConnectionPool({
    user: process.env._DB_USER,
    password: process.env.DB_PASS,
    server: process.env.DB_HOST, // Nombre del host o dirección IP
    database: process.env.DB_NAME,
    port: parseInt(process.env.DB_PORT, 10) || 1433, // Puerto, 1433 es el predeterminado para SQL Server
    pool: {
        max: 10, // Límite máximo de conexiones en el pool
        min: 0, // Límite mínimo de conexiones en el pool
        idleTimeoutMillis: 30000, // Tiempo en milisegundos antes de cerrar conexiones inactivas
    },
});

// Config session
app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Cambia a true si usas HTTPS
}));

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Config routes
app.use('/', routes);

app.listen(PORT, () => {
    console.log(`Server on port ${PORT}`);
});
