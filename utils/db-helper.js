const mysql = require('mysql2');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'admin',
    database: 'utube_mini',
    connectionLimit: 20
})

module.exports = pool;