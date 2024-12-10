const View = require('../models/viewModels');

// Controller untuk mengambil data produk
exports.getProduk = (req, res) => {
    View.getProduk((err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ result });
    });
};

// Controller untuk mengambil data review
exports.getReview = (req, res) => {
    View.getReview((err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ result });
    });
};

// Controller untuk mengambil data perbandingan produk
exports.getPerbandingan = (req, res) => {
    View.getPerbandingan((err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ result });
    });
};

// Controller untuk mengambil data wishlist produk
exports.getWishlist = (req, res) => {
    View.getWishlist((err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ result });
    });
};

// Controller untuk mengambil produk populer
exports.getProdukPopuler = (req, res) => {
    View.getProdukPopuler((err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ result });
    });
};
