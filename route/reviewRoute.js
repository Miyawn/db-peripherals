const express = require('express');
const router = express.Router();
const reviewController = require('../controller/reviewController');

// Routes
router.post('/add', reviewController.addReview); // Tambah review
router.put('/edit/:id', reviewController.editReview); // Edit review
router.delete('/delete/:id', reviewController.deleteReview); // Hapus review
router.get('/all', reviewController.getAllReviews); // Get all reviews
router.get('/:id', reviewController.getReviewById); // Get review by ID

module.exports = router;
