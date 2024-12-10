const express = require('express');
const router = express.Router();
const wishlistController = require('../controller/wishlistController');

// Routes
router.post('/add', wishlistController.addWishlist); // Add wishlist
router.delete('/delete/:id', wishlistController.deleteWishlist); // Delete wishlist
router.get('/all', wishlistController.getAllWishlist); // Get all wishlist
router.get('/user/:id_user', wishlistController.getWishlistByUser); // Get wishlist by user

module.exports = router;
