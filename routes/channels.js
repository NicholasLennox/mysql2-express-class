const express = require('express');
const router = express.Router();
const pool = require('../utils/db-helper');

// Get all channels
router.get('/', (req, res) => {
    // Get channel data
    const sql = 'SELECT id, channel_name, channel_email, is_deleted FROM channels';
    pool.query(sql, (err, results) => {
        if(err) {
            console.error(err);
        }
        console.log(results);
        // Render our channel list view
        res.render('channels/list', { channels: results });
    })
})

// Get add view
router.get('/add', (req, res) => {
    res.render('channels/add');
})

// Handle add
router.post('/add', (req, res) => {
    const { name, email } = req.body; // const name = req.body.name; const email = req.body.email
    console.log(`At add: ${name}, ${email}`);
    const sql = 'INSERT INTO channels(channel_name, channel_email) VALUES (?,?)';
    pool.query(sql, [name, email], (err, results) => {
        if(err){
            console.error(err);
        }
        res.redirect('/');
    })

})

// Get edit view
router.get('/edit/:id', (req, res) => {
    const { id } = req.params; // const id = req.params.id;
    // Fetch the channel by its id
    const sql = 'SELECT id, channel_name, channel_email FROM channels WHERE id = ?'
    pool.query(sql, [id], (err, results) => {
        if(err) {
            console.error(err);
        }
        console.log(results);
        res.render('channels/edit', { channel: results[0] })
    })
})

// Handle edit
router.post('/edit/:id', (req, res) => {
    const { name, email } = req.body;
    const { id } = req.params;
    // Update our channel
    const sql = 'UPDATE channels SET channel_name = ?, channel_email = ? WHERE id = ?';
    pool.query(sql, [name, email, id], (err, results) => {
        if(err){
            console.error(err);
        }
        res.redirect('/');
    })
})

// Handle delete
router.post('/delete/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'CALL sp_delete_channel(?)'
    pool.query(sql, [id], (err, results) => {
        if(err) {
            console.error(err);
            
        }
        res.redirect('/');
    })
})

module.exports = router;