const db = require('../config/database');

// Model untuk memanggil stored procedure getProduk
exports.getProduk = (callback) => {
    const query = 'CALL get_produk()';
    db.query(query, (err, result) => {
        if (err) {
            return callback(err);
        }
        return callback(null, result[0]); // result[0] mengandung hasil dari stored procedure
    });
};

// Model untuk memanggil stored procedure getReview
exports.getReview = (callback) => {
    const query = 'CALL get_review()';
    db.query(query, (err, result) => {
        if (err) {
            return callback(err);
        }
        return callback(null, result[0]);
    });
};

// Model untuk memanggil stored procedure getPerbandingan
exports.getPerbandingan = (callback) => {
    const query = 'CALL get_perbandingan()';
    db.query(query, (err, result) => {
        if (err) {
            return callback(err);
        }
        return callback(null, result[0]);
    });
};

// Model untuk memanggil stored procedure getWishlist
exports.getWishlist = (callback) => {
    const query = 'CALL get_wishlist()';
    db.query(query, (err, result) => {
        if (err) {
            return callback(err);
        }
        return callback(null, result[0]);
    });
};

// Model untuk memanggil stored procedure getProdukPopuler
exports.getProdukPopuler = (callback) => {
    const query = 'CALL get_produk_populer()';
    db.query(query, (err, result) => {
        if (err) {
            return callback(err);
        }
        return callback(null, result[0]);
    });
};
