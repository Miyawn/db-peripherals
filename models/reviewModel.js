const db = require('../config/database'); // Import konfigurasi database

// Tambah review
exports.addReview = ({ id_user, id_produk, deskripsi, kelebihan, kekurangan, rating }, callback) => {
    const query = 'CALL tambah_review(?, ?, ?, ?, ?, ?)';
    db.query(query, [id_user, id_produk, deskripsi, kelebihan, kekurangan, rating], callback);
};

// Edit review
exports.editReview = ({ id, deskripsi, kelebihan, kekurangan, rating }, callback) => {
    const query = 'CALL edit_review(?, ?, ?, ?, ?)';
    db.query(query, [id, deskripsi, kelebihan, kekurangan, rating], callback);
};

// Hapus review
exports.deleteReview = (id, callback) => {
    const query = 'CALL delete_review(?)';
    db.query(query, [id], callback);
};

// Get all reviews
exports.getAllReviews = (callback) => {
    const query = 'CALL get_all_reviews()';
    db.query(query, [], callback);
};

// Get review by ID
exports.getReviewById = (id, callback) => {
    const query = 'CALL get_review_by_id(?)';
    db.query(query, [id], callback);
};
