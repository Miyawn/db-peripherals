const db = require('../config/database');

// Add Perbandingan
exports.addPerbandingan = (id_user, id_produk1, id_produk2, callback) => {
    const query = 'CALL tambah_perbandingan(?, ?, ?)';
    db.query(query, [id_user, id_produk1, id_produk2], callback);
};

// Edit Perbandingan
exports.editPerbandingan = (id_perbandingan, id_produk1, id_produk2, callback) => {
    const query = 'CALL edit_perbandingan(?, ?, ?)';
    db.query(query, [id_perbandingan, id_produk1, id_produk2], callback);
};

// Delete Perbandingan
exports.deletePerbandingan = (id_perbandingan, callback) => {
    const query = 'CALL delete_perbandingan(?)';
    db.query(query, [id_perbandingan], callback);
};

// Get All Perbandingan
exports.getAllPerbandingan = (callback) => {
    const query = 'CALL get_all_perbandingan()';
    db.query(query, [], callback);
};

// Get Perbandingan by ID
exports.getPerbandinganById = (id_perbandingan, callback) => {
    const query = 'CALL get_perbandingan_by_id(?)';
    db.query(query, [id_perbandingan], callback);
};

// Get Perbandingan by User
exports.getPerbandinganByUser = (id_user, callback) => {
    const query = 'CALL get_perbandingan_by_user(?)';
    db.query(query, [id_user], callback);
};
