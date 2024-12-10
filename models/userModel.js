const db = require('../config/database');

// Register User
exports.registerUser = (data, callback) => {
    const query = 'CALL register_user(?, ?, ?, ?)';
    db.query(query, [data.nama, data.email, data.password, data.role], callback);
};

// Login User
exports.loginUser = (data, callback) => {
    const query = 'CALL login_user(?, ?)';
    db.query(query, [data.email, data.password], callback);
};

// Edit User
exports.editUser = (id, data, callback) => {
    const query = 'CALL edit_user(?, ?, ?, ?, ?)';
    db.query(query, [id, data.nama, data.email, data.password, data.role], callback);
};

// Delete User
exports.deleteUser = (id, callback) => {
    const query = 'CALL delete_user(?)';
    db.query(query, [id], callback);
};

// Get All Users
exports.getAllUsers = (callback) => {
    const query = 'CALL get_all_users()';
    db.query(query, [], callback);
};

// Get User by ID
exports.getUserById = (id, callback) => {
    const query = 'CALL get_user_by_id(?)';
    db.query(query, [id], callback);
};
