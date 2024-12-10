const db = require('../config/database');

// Tambah Produk
exports.tambahProduk = (data, callback) => {
    const query = 'CALL tambah_produk(?, ?, ?)';
    db.query(query, [data.nama, data.kategori, data.harga], callback);
};

// Edit Produk
exports.editProduk = (id, data, callback) => {
    const query = 'CALL edit_produk(?, ?, ?, ?)';
    db.query(query, [id, data.nama, data.kategori, data.harga], callback);
};

// Delete Produk
exports.deleteProduk = (id, callback) => {
    const query = 'CALL delete_produk(?)';
    db.query(query, [id], callback);
};

// Get All Produk
exports.getAllProduk = (callback) => {
    const query = 'CALL get_all_produk()';
    db.query(query, [], callback);
};

// Get Produk by ID
exports.getProdukById = (id, callback) => {
    const query = 'CALL get_produk_by_id(?)';
    db.query(query, [id], callback);
};
