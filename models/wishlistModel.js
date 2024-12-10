const db = require('../config/database');

// Add Wishlist
exports.addWishlist = (id_user, id_produk, callback) => {
    const query = 'CALL tambah_wishlist(?, ?)';
    db.query(query, [id_user, id_produk], callback);
};

// Delete Wishlist
exports.deleteWishlist = (id_wishlist, callback) => {
    const query = 'CALL delete_wishlist(?)';
    db.query(query, [id_wishlist], callback);
};

// Get All Wishlist
exports.getAllWishlist = (callback) => {
    const query = 'CALL get_all_wishlist()';
    db.query(query, [], callback);
};

// Get Wishlist by User
exports.getWishlistByUser = (id_user, callback) => {
    const query = 'CALL get_wishlist_by_user(?)';
    db.query(query, [id_user], callback);
};
