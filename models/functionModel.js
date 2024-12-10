const db = require('../config/database');

// Rekomendasi berdasarkan kategori
exports.rekomendasiBerdasarkanKategori = (kategori_produk, callback) => {
    const query = 'CALL rekomendasi_berdasarkan_kategori(?)';
    db.query(query, [kategori_produk], callback);
};

// Rekomendasi berdasarkan harga
exports.rekomendasiBerdasarkanHarga = (harga_min, harga_max, callback) => {
    const query = 'CALL rekomendasi_berdasarkan_harga(?, ?)';
    db.query(query, [harga_min, harga_max], callback);
};

// Rata-rata rating produk
exports.getAvgRatingProduk = (id_produk, callback) => {
    const query = 'CALL get_avg_rating_produk(?)';
    db.query(query, [id_produk], callback);
};

// Count review produk
exports.getCountReviewProduk = (id_produk, callback) => {
    const query = 'CALL get_count_review_produk(?)';
    db.query(query, [id_produk], callback);
};

// Count wishlist by user
exports.getCountWishlistByUser = (id_user, callback) => {
    const query = 'CALL get_count_wishlist_by_user(?)';
    db.query(query, [id_user], callback);
};
