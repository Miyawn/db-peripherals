const Function = require('../models/functionModel');

// Rekomendasi berdasarkan kategori
exports.rekomendasiBerdasarkanKategori = (req, res) => {
    const { kategori_produk } = req.body; // Menggunakan req.body untuk POST request

    // Memanggil method dari model functionModel untuk rekomendasi kategori
    Function.rekomendasiBerdasarkanKategori(kategori_produk, (err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }

        // Mengecek apakah hasilnya kosong
        if (result.length === 0) {
            return res.status(404).json({ message: 'Tidak ada produk yang ditemukan dalam kategori ini' });
        }

        // Mengirimkan hasil rekomendasi
        res.status(200).json({ result });
    });
};

// Rekomendasi berdasarkan harga
exports.rekomendasiBerdasarkanHarga = (req, res) => {
    const { harga_min, harga_max } = req.body; // Menggunakan req.body untuk POST request

    // Memanggil method dari model functionModel untuk rekomendasi berdasarkan harga
    Function.rekomendasiBerdasarkanHarga(harga_min, harga_max, (err, result) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }

        // Mengecek apakah hasilnya kosong
        if (result.length === 0) {
            return res.status(404).json({ message: 'Tidak ada produk yang ditemukan dalam rentang harga ini' });
        }

        // Mengirimkan hasil rekomendasi
        res.status(200).json({ result });
    });
};


// Rata-rata rating produk
exports.getAvgRatingProduk = (req, res) => {
    const { id_produk } = req.params;
    Function.getAvgRatingProduk(id_produk, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ result });
    });
};

// Count review produk
exports.getCountReviewProduk = (req, res) => {
    const { id_produk } = req.params;
    Function.getCountReviewProduk(id_produk, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ result });
    });
};

// Count wishlist by user
exports.getCountWishlistByUser = (req, res) => {
    const { id_user } = req.params;
    Function.getCountWishlistByUser(id_user, (err, result) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ result });
    });
};
