const express = require('express');
const router = express.Router();
const produkController = require('../controller/produkController');

// Routes
router.post('/add', produkController.tambahProduk);
router.put('/edit/:id', produkController.editProduk);
router.delete('/delete/:id', produkController.deleteProduk);
router.get('/all', produkController.getAllProduk);
router.get('/:id', produkController.getProdukById);

module.exports = router;
