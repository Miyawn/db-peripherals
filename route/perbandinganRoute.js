const express = require('express');
const router = express.Router();
const perbandinganController = require('../controller/perbandinganController');

// Routes
router.post('/add', perbandinganController.addPerbandingan); // Add comparison
router.put('/edit/:id', perbandinganController.editPerbandingan); // Edit comparison
router.delete('/delete/:id', perbandinganController.deletePerbandingan); // Delete comparison
router.get('/all', perbandinganController.getAllPerbandingan); // Get all comparisons
router.get('/:id', perbandinganController.getPerbandinganById); // Get comparison by ID
router.get('/user/:id_user', perbandinganController.getPerbandinganByUser); // Get comparison by user ID

module.exports = router;
