const Review = require('../models/reviewModel');

// Tambah review
exports.addReview = (req, res) => {
    const { id_user, id_produk, deskripsi, kelebihan, kekurangan, rating } = req.body;

    if (!id_user || !id_produk || !deskripsi || !rating) {
        return res.status(400).json({ message: "Semua field wajib diisi (id_user, id_produk, deskripsi, rating)." });
    }

    Review.addReview({ id_user, id_produk, deskripsi, kelebihan, kekurangan, rating }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(201).json({ message: "Review berhasil ditambahkan.", data: results });
    });
};

// Edit review
exports.editReview = (req, res) => {
    const { id } = req.params;
    const { deskripsi, kelebihan, kekurangan, rating } = req.body;

    if (!id) {
        return res.status(400).json({ message: "ID review diperlukan untuk mengedit." });
    }

    Review.editReview({ id, deskripsi, kelebihan, kekurangan, rating }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: "Review berhasil diperbarui.", data: results });
    });
};

// Hapus review
exports.deleteReview = (req, res) => {
    const { id } = req.params;

    if (!id) {
        return res.status(400).json({ message: "ID review diperlukan untuk menghapus." });
    }

    Review.deleteReview(id, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: "Review berhasil dihapus.", data: results });
    });
};

// Get all reviews
exports.getAllReviews = (req, res) => {
    Review.getAllReviews((err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ data: results });
    });
};

// Get review by ID
exports.getReviewById = (req, res) => {
    const { id } = req.params;

    if (!id) {
        return res.status(400).json({ message: "ID review diperlukan untuk mengambil data." });
    }

    Review.getReviewById(id, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ data: results });
    });
};
