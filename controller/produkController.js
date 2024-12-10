const Produk = require('../models/produkModel');

// Tambah Produk
exports.tambahProduk = (req, res) => {
    const { nama, kategori, harga } = req.body;

    if (!nama || !kategori || !harga) {
        return res.status(400).json({ message: 'Semua field harus diisi' });
    }

    Produk.tambahProduk({ nama, kategori, harga }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(201).json({ message: 'Produk berhasil ditambahkan' });
    });
};

// Edit Produk
exports.editProduk = (req, res) => {
    const { id } = req.params;
    const { nama, kategori, harga } = req.body;

    if (!nama || !kategori || !harga) {
        return res.status(400).json({ message: 'Semua field harus diisi' });
    }

    Produk.editProduk(id, { nama, kategori, harga }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'Produk berhasil diperbarui' });
    });
};

// Delete Produk
exports.deleteProduk = (req, res) => {
    const { id } = req.params;

    Produk.deleteProduk(id, (err) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'Produk berhasil dihapus' });
    });
};

// Get All Produk
exports.getAllProduk = (req, res) => {
    Produk.getAllProduk((err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ produk: results });
    });
};

// Get Produk by ID
exports.getProdukById = (req, res) => {
    const { id } = req.params;

    Produk.getProdukById(id, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ produk: results[0] });
    });
};
