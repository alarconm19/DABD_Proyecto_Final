const express = require('express');
const { engine } = require('express-handlebars');
const session = require('express-session');
const path = require('path');
const sql = require('mssql');
const routes = require('./routes/routes');
require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 4000;

// Config handlebars
app.set('views', __dirname + '/views');
app.engine('.hbs', engine({
    extname: '.hbs'
}));
app.set('view engine', '.hbs');

// Config public folder
app.use(express.static(path.join(__dirname, '..', 'public')));

// Crear un pool de conexiones
const poolPromise = new sql.ConnectionPool({
    user: process.env.AZURE_USER,        // Usuario de SQL Server
    password: process.env.AZURE_PASS, // Contraseña del usuario
    server: process.env.AZURE_HOST, // Servidor de la instancia en Azure
    database: process.env.AZURE_DB,      // Nombre de la base de datos
    port: 1433, // Puerto de la base de datos
    // options: {
    //     encrypt: true, // Requerido para conexiones con Azure SQL
    //     trustServerCertificate: false, // Cambiar a true si no usas certificados
    // },
}).connect();

app.use((req, res, next) => {
    // Obtener la conexión del pool
    poolPromise
        .then(pool => {
            // Obtener el objeto de solicitud de la base de datos
            req.conn = pool.request();
            next();
        })
        .catch(err => {
            console.error('Error al conectar a la base de datos:', err);
            next(err); // Pasar el error al siguiente middleware
        });
});

// Config session
app.use(session({
    secret: 'your-fasdfas-fas',
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
