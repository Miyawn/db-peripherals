const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');

// Routes
router.post('/register', userController.registerUser);
router.post('/login', userController.loginUser);
router.put('/edit/:id', userController.editUser);
router.delete('/delete/:id', userController.deleteUser);
router.get('/all', userController.getAllUsers);
router.get('/:id', userController.getUserById);

module.exports = router;
