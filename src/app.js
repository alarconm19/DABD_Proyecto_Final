const express = require ('express');
const { engine } = require ('express-handlebars');
const session = require ('express-session');
const path = require('path');
const routes = require('./routes/routes');
require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 4000;

app.set('views', __dirname + '/views');
app.engine('.hbs', engine ({
    extname: '.hbs'
}));
app.set('view engine', '.hbs');

app.use(express.static(path.join(__dirname, '..', 'public')));

// Config database


// Config session
app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Cambia a true si usas HTTPS
}));

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.listen(PORT, () => {
    console.log(`Server on port ${PORT}`);
});

app.use('/', routes);
