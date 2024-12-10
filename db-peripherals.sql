USE peripherals;

create user 'admin_rekomendasi'@'localhost' identified by 'admin123';
grant execute on `peripherals`.* to 'admin_rekomendasi'@'localhost';
flush privileges;

--------------------------------------------------------------------------------------------------------------------
-- 1. Tabel

-- 1. Tabel Users (gabungan admin dan user)
CREATE TABLE users (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') NOT NULL
);

-- 2. Tabel Produk
CREATE TABLE produk (
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(255) NOT NULL,
    kategori VARCHAR(255) NOT NULL,
    harga VARCHAR(255) NOT NULL
);

-- 3. Tabel Review
CREATE TABLE review (
    id_review INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    id_produk INT NOT NULL,
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk) ON DELETE CASCADE,
    deskripsi VARCHAR(255) NOT NULL,
    kelebihan VARCHAR(255),
    kekurangan VARCHAR(255),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    tanggal_review DATETIM  DEFAULT CURRENT_TIMESTAMP
);


-- 4. Tabel Perbandingan (gabungan perbandingan dan produkperbandingan)
create or replace TABLE perbandingan (
    id_perbandingan INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    id_produk1 INT NOT NULL,
    FOREIGN KEY (id_produk1) REFERENCES produk(id_produk) ON DELETE CASCADE,
    id_produk2 INT NOT NULL,
    FOREIGN KEY (id_produk2) REFERENCES produk(id_produk) ON DELETE CASCADE,
    tanggal_perbandingan DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- 5. Tabel Wishlist (referensi ke user dan produk)
CREATE TABLE wishlist (
    id_wishlist INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    id_produk INT NOT NULL,
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk) ON DELETE CASCADE,
    tanggal_ditambahkan DATETIME DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------------------------------------------------------------------------
-- 1. Procedure Table User

DELIMITER //
CREATE PROCEDURE register_user(
    IN _nama VARCHAR(255),
    IN _email VARCHAR(255),
    IN _password VARCHAR(255),
    IN _role ENUM('admin', 'user')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi input
    IF LENGTH(_email) < 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email minimal 5 karakter';
    END IF;

    IF LENGTH(_password) < 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password minimal 8 karakter';
    END IF;

    -- Insert data user baru
    INSERT INTO users (nama, email, password, role)
    VALUES (_nama, _email, SHA2(_password, 256), COALESCE(_role, 'user'));

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE login_user(
    IN _email VARCHAR(255),
    IN _password VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi Login
    IF NOT EXISTS (
        SELECT 1 FROM users
        WHERE email = _email AND password = SHA2(_password, 256)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email atau password salah';
    END IF;

    -- Return data user
    SELECT id_user, nama, email, role
    FROM users
    WHERE email = _email AND password = SHA2(_password, 256);

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE edit_user(
    IN _id_user INT,
    IN _nama VARCHAR(255),
    IN _email VARCHAR(255),
    IN _password VARCHAR(255),
    IN _role ENUM('admin', 'user')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE users
    SET 
        nama = COALESCE(_nama, nama),
        email = COALESCE(_email, email),
        password = COALESCE(SHA2(_password, 256), password),
        role = COALESCE(_role, role)
    WHERE id_user = _id_user;

    COMMIT;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE delete_user(
    IN _id_user INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM users WHERE id_user = _id_user;

    COMMIT;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE get_all_users()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id_user, nama, email, role FROM users;

    COMMIT;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE get_user_by_id(
    IN _id_user INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id_user, nama, email, role
    FROM users
    WHERE id_user = _id_user;

    COMMIT;
END//
DELIMITER ;

--------------------------------------------------------------------------------------------------------------------
-- 2. Procedure Table Produk

DELIMITER //
CREATE PROCEDURE tambah_produk(
    IN _nama VARCHAR(255),
    IN _kategori VARCHAR(255),
    IN _harga VARCHAR(255)
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi nama
    IF CHAR_LENGTH(COALESCE(_nama, '')) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nama produk tidak boleh kosong';
    END IF;

    -- Validasi kategori
    IF CHAR_LENGTH(COALESCE(_kategori, '')) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kategori produk tidak boleh kosong';
    END IF;

    -- Validasi harga
    IF NOT (_harga REGEXP '^[0-9]+(\.[0-9]{1,2})?$') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga harus berupa angka dengan maksimal dua desimal';
    END IF;

    -- Menambahkan produk baru
    INSERT INTO produk (nama, kategori, harga)
    VALUES (_nama, _kategori, _harga);

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE edit_produk(
    IN _id_produk INT,
    IN _nama VARCHAR(255),
    IN _kategori VARCHAR(255),
    IN _harga VARCHAR(255)
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi keberadaan produk
    IF NOT EXISTS (SELECT 1 FROM produk WHERE id_produk = _id_produk) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produk dengan ID tersebut tidak ditemukan';
    END IF;

    -- Validasi harga jika diberikan
    IF _harga IS NOT NULL AND NOT (_harga REGEXP '^[0-9]+(\.[0-9]{1,2})?$') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga harus berupa angka dengan maksimal dua desimal';
    END IF;

    -- Mengupdate produk
    UPDATE produk
    SET 
        nama = COALESCE(_nama, nama),
        kategori = COALESCE(_kategori, kategori),
        harga = COALESCE(_harga, harga)
    WHERE id_produk = _id_produk;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_produk(
    IN _id_produk INT
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi keberadaan produk
    IF NOT EXISTS (SELECT 1 FROM produk WHERE id_produk = _id_produk) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produk dengan ID tersebut tidak ditemukan';
    END IF;

    -- Menghapus produk
    DELETE FROM produk
    WHERE id_produk = _id_produk;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_produk()
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Mengambil semua data produk
    SELECT id_produk, nama, kategori, harga
    FROM produk;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_produk_by_id(
    IN _id_produk INT
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi keberadaan produk
    IF NOT EXISTS (SELECT 1 FROM produk WHERE id_produk = _id_produk) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produk dengan ID tersebut tidak ditemukan';
    END IF;

    -- Mengambil data produk berdasarkan ID
    SELECT id_produk, nama, kategori, harga
    FROM produk
    WHERE id_produk = _id_produk;

    COMMIT;
END//
DELIMITER ;

--------------------------------------------------------------------------------------------------------------------
-- 3. Procedure Table Review

DELIMITER //
CREATE PROCEDURE tambah_review(
    IN _id_user INT,
    IN _id_produk INT,
    IN _deskripsi VARCHAR(255),
    IN _kelebihan VARCHAR(255),
    IN _kekurangan VARCHAR(255),
    IN _rating INT
)
BEGIN
    -- Error Handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi input
    IF (_rating < 1 OR _rating > 5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating harus berada di antara 1 dan 5';
    END IF;

    -- Tambahkan review baru
    INSERT INTO review (id_user, id_produk, deskripsi, kelebihan, kekurangan, rating)
    VALUES (_id_user, _id_produk, _deskripsi, _kelebihan, _kekurangan, _rating);

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE edit_review(
    IN _id_review INT,
    IN _deskripsi VARCHAR(255),
    IN _kelebihan VARCHAR(255),
    IN _kekurangan VARCHAR(255),
    IN _rating INT
)
BEGIN
    -- Error Handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi input
    IF (_rating IS NOT NULL AND (_rating < 1 OR _rating > 5)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating harus berada di antara 1 dan 5';
    END IF;

    -- Update review
    UPDATE review
    SET 
        deskripsi = COALESCE(_deskripsi, deskripsi),
        kelebihan = COALESCE(_kelebihan, kelebihan),
        kekurangan = COALESCE(_kekurangan, kekurangan),
        rating = COALESCE(_rating, rating)
    WHERE id_review = _id_review;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_review(
    IN _id_review INT
)
BEGIN
    -- Error Handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Hapus review
    DELETE FROM review
    WHERE id_review = _id_review;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_reviews()
BEGIN
    -- Error Handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Ambil semua data review
    SELECT id_review, id_user, id_produk, deskripsi, kelebihan, kekurangan, rating, tanggal_review
    FROM review;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_review_by_id(
    IN _id_review INT
)
BEGIN
    -- Error Handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Ambil review berdasarkan id
    SELECT id_review, id_user, id_produk, deskripsi, kelebihan, kekurangan, rating, tanggal_review
    FROM review
    WHERE id_review = _id_review;

    COMMIT;
END//
DELIMITER ;

--------------------------------------------------------------------------------------------------------------------
-- 4. Procedure Table Perbandingan

DELIMITER //
CREATE PROCEDURE tambah_perbandingan(
    IN _id_user INT,
    IN _id_produk1 INT,
    IN _id_produk2 INT
)
BEGIN
    INSERT INTO perbandingan (id_user, id_produk1, id_produk2)
    VALUES (_id_user, _id_produk1, _id_produk2);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE edit_perbandingan(
    IN _id_perbandingan INT,
    IN _id_produk1 INT,
    IN _id_produk2 INT
)
BEGIN
    UPDATE perbandingan
    SET 
        id_produk1 = COALESCE(_id_produk1, id_produk1),
        id_produk2 = COALESCE(_id_produk2, id_produk2)
    WHERE id_perbandingan = _id_perbandingan;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_perbandingan(
    IN _id_perbandingan INT
)
BEGIN
    DELETE FROM perbandingan
    WHERE id_perbandingan = _id_perbandingan;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_perbandingan()
BEGIN
    SELECT 
        p.id_perbandingan, 
        p.id_user, 
        u.nama AS nama_user, 
        p.id_produk1, 
        prod1.nama AS nama_produk1, 
        p.id_produk2, 
        prod2.nama AS nama_produk2, 
        p.tanggal_perbandingan
    FROM perbandingan p
    JOIN users u ON p.id_user = u.id_user
    JOIN produk prod1 ON p.id_produk1 = prod1.id_produk
    JOIN produk prod2 ON p.id_produk2 = prod2.id_produk;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_perbandingan_by_id(
    IN _id_perbandingan INT
)
BEGIN
    SELECT 
        p.id_perbandingan, 
        p.id_user, 
        u.nama AS nama_user, 
        p.id_produk1, 
        prod1.nama AS nama_produk1, 
        p.id_produk2, 
        prod2.nama AS nama_produk2, 
        p.tanggal_perbandingan
    FROM perbandingan p
    JOIN users u ON p.id_user = u.id_user
    JOIN produk prod1 ON p.id_produk1 = prod1.id_produk
    JOIN produk prod2 ON p.id_produk2 = prod2.id_produk
    WHERE p.id_perbandingan = _id_perbandingan;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_perbandingan_by_user(
    IN _id_user INT
)
BEGIN
    SELECT 
        p.id_perbandingan, 
        p.id_user, 
        u.nama AS nama_user, 
        p.id_produk1, 
        prod1.nama AS nama_produk1, 
        p.id_produk2, 
        prod2.nama AS nama_produk2, 
        p.tanggal_perbandingan
    FROM perbandingan p
    JOIN users u ON p.id_user = u.id_user
    JOIN produk prod1 ON p.id_produk1 = prod1.id_produk
    JOIN produk prod2 ON p.id_produk2 = prod2.id_produk
    WHERE p.id_user = _id_user;
END //
DELIMITER ;

--------------------------------------------------------------------------------------------------------------------
-- 5. Procedure Table Wishlist

DELIMITER //
CREATE PROCEDURE tambah_wishlist(
    IN _id_user INT,
    IN _id_produk INT
)
BEGIN
    INSERT INTO wishlist (id_user, id_produk)
    VALUES (_id_user, _id_produk);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_wishlist(
    IN _id_wishlist INT
)
BEGIN
    DELETE FROM wishlist
    WHERE id_wishlist = _id_wishlist;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_wishlist()
BEGIN
    SELECT 
        w.id_wishlist, 
        w.id_user, 
        u.nama AS nama_user, 
        w.id_produk, 
        p.nama AS nama_produk, 
        w.tanggal_ditambahkan
    FROM wishlist w
    JOIN users u ON w.id_user = u.id_user
    JOIN produk p ON w.id_produk = p.id_produk;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_wishlist_by_user(
    IN _id_user INT
)
BEGIN
    SELECT 
        w.id_wishlist, 
        w.id_user, 
        u.nama AS nama_user, 
        w.id_produk, 
        p.nama AS nama_produk, 
        w.tanggal_ditambahkan
    FROM wishlist w
    JOIN users u ON w.id_user = u.id_user
    JOIN produk p ON w.id_produk = p.id_produk
    WHERE w.id_user = _id_user;
END //
DELIMITER ;

--------------------------------------------------------------------------------------------------------------------
-- Stored Function

drop procedure if exists rekomendasi_berdasarkan_kategori;
drop procedure if exists rekomendasi_berdasarkan_harga;
drop procedure if exists get_avg_rating_produk;
drop procedure if exists get_count_review_produk;
drop procedure if exists get_count_wishlist_by_user;

DELIMITER //
CREATE PROCEDURE rekomendasi_berdasarkan_kategori(
    IN kategori_produk VARCHAR(255)
)
BEGIN
    DECLARE produk_count INT;
    START TRANSACTION;
    SELECT COUNT(id_produk) INTO produk_count
    FROM produk
    WHERE kategori = kategori_produk;
    IF produk_count = 0 THEN
        ROLLBACK;
        SELECT 'Tidak ada produk yang ditemukan dalam kategori ini.' AS pesan;
    ELSE
        COMMIT;
        SELECT p.id_produk, p.nama, AVG(r.rating) AS rata_rating
        FROM produk p
        JOIN review r ON p.id_produk = r.id_produk
        WHERE p.kategori = kategori_produk
        GROUP BY p.id_produk, p.nama
        ORDER BY rata_rating DESC;
    END IF;
END //
DELIMITER ;

CALL rekomendasi_berdasarkan_kategori('Mechanical');

DELIMITER //
CREATE PROCEDURE rekomendasi_berdasarkan_harga(
    IN harga_min DECIMAL(10, 2),
    IN harga_max DECIMAL(10, 2)
)
BEGIN
    START TRANSACTION;
    IF harga_min < 0 OR harga_max < 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Harga tidak boleh negatif';
    END IF;
    IF harga_min > harga_max THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Harga minimum tidak boleh lebih besar dari harga maksimum';
    END IF;
    COMMIT;
    SELECT p.id_produk, p.nama, AVG(r.rating) AS rata_rating
    FROM produk p
    JOIN review r ON p.id_produk = r.id_produk
    WHERE p.harga BETWEEN harga_min AND harga_max
    GROUP BY p.id_produk, p.nama
    ORDER BY rata_rating DESC;
END //
DELIMITER ;

CALL rekomendasi_berdasarkan_harga(100000, 20000000);

DELIMITER //
CREATE PROCEDURE get_avg_rating_produk(
    IN _id_produk INT
)
BEGIN
    START TRANSACTION;
    SELECT 
        IFNULL(AVG(rating), 0) AS rata_rating
    FROM review
    WHERE id_produk = _id_produk;
    COMMIT;
END //
DELIMITER ;

CALL get_avg_rating_produk(3);

DELIMITER //
CREATE PROCEDURE get_count_review_produk(
    IN _id_produk INT
)
BEGIN
    START TRANSACTION;
    SELECT 
        COUNT(id_review) AS total_review
    FROM review
    WHERE id_produk = _id_produk;
    COMMIT;
END //
DELIMITER ;

CALL get_count_review_produk(3);

DELIMITER //
CREATE PROCEDURE get_count_wishlist_by_user(
    IN _id_user INT
)
BEGIN
    START TRANSACTION;
    SELECT 
        COUNT(id_wishlist) AS total_wishlist
    FROM wishlist
    WHERE id_user = _id_user;
    COMMIT;
END //
DELIMITER ;

CALL get_count_wishlist_by_user(2);

--------------------------------------------------------------------------------------------------------------------
-- Views

-- View untuk menampilkan daftar produk dengan informasi dasar
CREATE OR REPLACE VIEW view_produk AS
SELECT 
    p.id_produk, 
    p.nama AS nama_produk, 
    p.kategori, 
    p.harga
FROM produk p;

-- View untuk menampilkan daftar review lengkap termasuk informasi pengguna dan produk
CREATE OR REPLACE VIEW view_review AS
SELECT 
    r.id_review,
    u.nama AS nama_user,
    p.nama AS nama_produk,
    r.deskripsi,
    r.kelebihan,
    r.kekurangan,
    r.rating,
    r.tanggal_review
FROM review r
JOIN users u ON r.id_user = u.id_user
JOIN produk p ON r.id_produk = p.id_produk;

-- View untuk menampilkan daftar perbandingan produk antara dua produk
CREATE OR REPLACE VIEW view_perbandingan AS
SELECT 
    p.id_perbandingan,
    u.nama AS nama_user,
    p1.nama AS nama_produk1,
    p2.nama AS nama_produk2,
    p.tanggal_perbandingan
FROM perbandingan p
JOIN users u ON p.id_user = u.id_user
JOIN produk p1 ON p.id_produk1 = p1.id_produk
JOIN produk p2 ON p.id_produk2 = p2.id_produk;

-- View untuk menampilkan daftar wishlist produk pengguna
CREATE OR REPLACE VIEW view_wishlist AS
SELECT 
    w.id_wishlist,
    u.nama AS nama_user,
    p.nama AS nama_produk,
    w.tanggal_ditambahkan
FROM wishlist w
JOIN users u ON w.id_user = u.id_user
JOIN produk p ON w.id_produk = p.id_produk;

-- View untuk menampilkan detail produk yang sering direview atau dibandingkan
CREATE OR REPLACE VIEW view_produk_populer AS
SELECT 
    p.id_produk,
    p.nama AS nama_produk,
    COUNT(r.id_review) AS jumlah_review,
    COUNT(pc.id_perbandingan) AS jumlah_perbandingan
FROM produk p
LEFT JOIN review r ON p.id_produk = r.id_produk
LEFT JOIN perbandingan pc ON p.id_produk = pc.id_produk1 OR p.id_produk = pc.id_produk2
GROUP BY p.id_produk, p.nama
ORDER BY jumlah_review DESC, jumlah_perbandingan DESC;

SELECT * FROM view_produk;
SELECT * FROM view_review;
SELECT * FROM view_perbandingan;
SELECT * FROM view_wishlist;
SELECT * FROM view_produk_populer;

--------------------------------------------------------------------------------------------------------------------
-- Stored Views

-- Stored Procedure untuk menampilkan daftar produk dengan informasi dasar
DELIMITER //
CREATE PROCEDURE get_produk()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data produk.';
    END;

    START TRANSACTION;
    SELECT 
        p.id_produk, 
        p.nama AS nama_produk, 
        p.kategori, 
        p.harga
    FROM produk p;
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure untuk menampilkan daftar review lengkap termasuk informasi pengguna dan produk
DELIMITER //
CREATE PROCEDURE get_review()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data review.';
    END;

    START TRANSACTION;
    SELECT 
        r.id_review,
        u.nama AS nama_user,
        p.nama AS nama_produk,
        r.deskripsi,
        r.kelebihan,
        r.kekurangan,
        r.rating,
        r.tanggal_review
    FROM review r
    JOIN users u ON r.id_user = u.id_user
    JOIN produk p ON r.id_produk = p.id_produk;
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure untuk menampilkan daftar perbandingan produk antara dua produk
DELIMITER //
CREATE PROCEDURE get_perbandingan()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data perbandingan produk.';
    END;

    START TRANSACTION;
    SELECT 
        p.id_perbandingan,
        u.nama AS nama_user,
        p1.nama AS nama_produk1,
        p2.nama AS nama_produk2,
        p.tanggal_perbandingan
    FROM perbandingan p
    JOIN users u ON p.id_user = u.id_user
    JOIN produk p1 ON p.id_produk1 = p1.id_produk
    JOIN produk p2 ON p.id_produk2 = p2.id_produk;
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure untuk menampilkan daftar wishlist produk pengguna
DELIMITER //
CREATE PROCEDURE get_wishlist()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data wishlist.';
    END;

    START TRANSACTION;
    SELECT 
        w.id_wishlist,
        u.nama AS nama_user,
        p.nama AS nama_produk,
        w.tanggal_ditambahkan
    FROM wishlist w
    JOIN users u ON w.id_user = u.id_user
    JOIN produk p ON w.id_produk = p.id_produk;
    COMMIT;
END //
DELIMITER ;

-- Stored Procedure untuk menampilkan detail produk yang sering direview atau dibandingkan
DELIMITER //
CREATE PROCEDURE get_produk_populer()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data produk populer.';
    END;

    START TRANSACTION;
    SELECT 
        p.id_produk,
        p.nama AS nama_produk,
        COUNT(r.id_review) AS jumlah_review,
        COUNT(pc.id_perbandingan) AS jumlah_perbandingan
    FROM produk p
    LEFT JOIN review r ON p.id_produk = r.id_produk
    LEFT JOIN perbandingan pc ON p.id_produk = pc.id_produk1 OR p.id_produk = pc.id_produk2
    GROUP BY p.id_produk, p.nama
    ORDER BY jumlah_review DESC, jumlah_perbandingan DESC;
    COMMIT;
END //
DELIMITER ;


--------------------------------------------------------------------------------------------------------------------
-- Trigger

DELIMITER //
CREATE TRIGGER before_wishlist_insert
BEFORE INSERT ON wishlist
FOR EACH ROW
BEGIN
    DECLARE existing_count INT;

    -- Cek apakah produk yang sama sudah ada di wishlist
    SELECT COUNT(*) INTO existing_count
    FROM wishlist
    WHERE id_user = NEW.id_user AND id_produk = NEW.id_produk;

    -- Jika sudah ada, batalkan insert
    IF existing_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produk sudah ada di wishlist Anda.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_product_delete
BEFORE DELETE ON produk
FOR EACH ROW
BEGIN
    -- Hapus semua review terkait produk yang akan dihapus
    DELETE FROM review WHERE id_produk = OLD.id_produk;

    -- Hapus semua wishlist terkait produk yang akan dihapus
    DELETE FROM wishlist WHERE id_produk = OLD.id_produk;

    -- Hapus semua perbandingan produk yang akan dihapus
    DELETE FROM perbandingan WHERE id_produk1 = OLD.id_produk OR id_produk2 = OLD.id_produk;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_product_delete
AFTER DELETE ON produk
FOR EACH ROW
BEGIN
    -- Hapus produk yang dihapus dari wishlist
    DELETE FROM wishlist WHERE id_produk = OLD.id_produk;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_product_delete_from_comparison
AFTER DELETE ON produk
FOR EACH ROW
BEGIN
    -- Menghapus semua perbandingan yang melibatkan produk yang dihapus
    DELETE FROM perbandingan WHERE id_produk1 = OLD.id_produk OR id_produk2 = OLD.id_produk;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_wishlist_insert_limit
BEFORE INSERT ON wishlist
FOR EACH ROW
BEGIN
    DECLARE wishlist_count INT;

    -- Menghitung jumlah produk di wishlist pengguna
    SELECT COUNT(*) INTO wishlist_count
    FROM wishlist
    WHERE id_user = NEW.id_user;

    -- Batalkan insert jika jumlah wishlist sudah mencapai batas
    IF wishlist_count >= 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Anda sudah mencapai batas maksimal wishlist.';
    END IF;
END //
DELIMITER ;


