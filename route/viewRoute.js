const express = require('express');
const router = express.Router();
const viewController = require('../controller/viewController');

// Endpoint untuk mengambil data produk
router.get('/produk', viewController.getProduk);

// Endpoint untuk mengambil data review
router.get('/review', viewController.getReview);

// Endpoint untuk mengambil data perbandingan produk
router.get('/perbandingan', viewController.getPerbandingan);

// Endpoint untuk mengambil data wishlist produk
router.get('/wishlist', viewController.getWishlist);

// Endpoint untuk mengambil produk populer
router.get('/produk-populer', viewController.getProdukPopuler);

module.exports = router;
