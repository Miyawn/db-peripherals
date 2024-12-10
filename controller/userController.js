const User = require('../models/userModel');

// Register User
exports.registerUser = (req, res) => {
    const { nama, email, password, role } = req.body;

    User.registerUser({ nama, email, password, role }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(201).json({ message: 'User registered successfully' });
    });
};

// Login User
exports.loginUser = (req, res) => {
    const { email, password } = req.body;

    User.loginUser({ email, password }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ user: results[0] });
    });
};

// Edit User
exports.editUser = (req, res) => {
    const { id } = req.params;
    const { nama, email, password, role } = req.body;

    User.editUser(id, { nama, email, password, role }, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'User updated successfully' });
    });
};

// Delete User
exports.deleteUser = (req, res) => {
    const { id } = req.params;

    User.deleteUser(id, (err) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ message: 'User deleted successfully' });
    });
};

// Get All Users
exports.getAllUsers = (req, res) => {
    User.getAllUsers((err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ users: results });
    });
};

// Get User by ID
exports.getUserById = (req, res) => {
    const { id } = req.params;

    User.getUserById(id, (err, results) => {
        if (err) return res.status(500).json({ message: err.sqlMessage });
        res.status(200).json({ user: results[0] });
    });
};
