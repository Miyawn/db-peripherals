const Perbandingan = require('../models/perbandinganModel');

// Add Perbandingan
exports.addPerbandingan = (req, res) => {
    const { id_user, id_produk1, id_produk2 } = req.body;
    Perbandingan.addPerbandingan(id_user, id_produk1, id_produk2, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(201).json({ message: 'Perbandingan berhasil ditambahkan', result });
    });
};

// Edit Perbandingan
exports.editPerbandingan = (req, res) => {
    const id_perbandingan = req.params.id;
    const { id_produk1, id_produk2 } = req.body;
    Perbandingan.editPerbandingan(id_perbandingan, id_produk1, id_produk2, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'Perbandingan berhasil diperbarui', result });
    });
};

// Delete Perbandingan
exports.deletePerbandingan = (req, res) => {
    const id_perbandingan = req.params.id;
    Perbandingan.deletePerbandingan(id_perbandingan, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'Perbandingan berhasil dihapus', result });
    });
};

// Get All Perbandingan
exports.getAllPerbandingan = (req, res) => {
    Perbandingan.getAllPerbandingan((err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ perbandingan: results });
    });
};

// Get Perbandingan by ID
exports.getPerbandinganById = (req, res) => {
    const id_perbandingan = req.params.id;
    Perbandingan.getPerbandinganById(id_perbandingan, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        if (!result.length) return res.status(404).json({ message: 'Perbandingan tidak ditemukan' });
        res.status(200).json({ perbandingan: result[0] });
    });
};

// Get Perbandingan by User
exports.getPerbandinganByUser = (req, res) => {
    const id_user = req.params.id_user;
    Perbandingan.getPerbandinganByUser(id_user, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ perbandingan: results });
    });
};
