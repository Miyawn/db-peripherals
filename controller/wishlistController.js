const Wishlist = require('../models/wishlistModel');

// Add Wishlist
exports.addWishlist = (req, res) => {
    const { id_user, id_produk } = req.body;
    Wishlist.addWishlist(id_user, id_produk, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(201).json({ message: 'Wishlist berhasil ditambahkan', result });
    });
};

// Delete Wishlist
exports.deleteWishlist = (req, res) => {
    const id_wishlist = req.params.id;
    Wishlist.deleteWishlist(id_wishlist, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'Wishlist berhasil dihapus', result });
    });
};

// Get All Wishlist
exports.getAllWishlist = (req, res) => {
    Wishlist.getAllWishlist((err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ wishlist: results });
    });
};

// Get Wishlist by User
exports.getWishlistByUser = (req, res) => {
    const id_user = req.params.id_user;
    Wishlist.getWishlistByUser(id_user, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ wishlist: results });
    });
};
