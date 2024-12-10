const express = require('express');
const router = express.Router();
const functionController = require('../controller/functionController');

// Routes
router.get('/kategori', functionController.rekomendasiBerdasarkanKategori);
router.get('/harga', functionController.rekomendasiBerdasarkanHarga);
router.get('/rating/:id_produk', functionController.getAvgRatingProduk);
router.get('/count-review/:id_produk', functionController.getCountReviewProduk);
router.get('/count-wishlist/:id_user', functionController.getCountWishlistByUser);

module.exports = router;
