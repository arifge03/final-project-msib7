const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');
require('dotenv').config();

const userController = {
    async register(req, res) {
        const { username, password } = req.body;
        const image = req.file ? `/uploads/${req.file.filename}` : null;
        try {
            if (!username || !password) {
                return res.status(400).json({ error: 'Username and password are required' });
            }

            const hashedPassword = await bcrypt.hash(password, 10);
            const newUser = await User.create({ 
                username, 
                password: hashedPassword, 
                image
            });

            delete newUser.dataValues.password;

            res.status(201).json({ message: 'Registration successful', user: newUser });
        } catch (error) {
            console.error('Error in register:', error);
            res.status(400).json({ error: 'Failed to register user' });
        }
    },

    async login(req, res) {
        const { username, password } = req.body;
        try {
            const user = await User.findOne({ where: { username } });
            if (!user) {
                return res.status(404).json({ error: 'User not found' });
            }

            const isValidPassword = await bcrypt.compare(password, user.password);
            if (!isValidPassword) {
                return res.status(401).json({ error: 'Invalid credentials' });
            }

            const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });
            res.json({ token });
        } catch (error) {
            console.error('Error in login:', error);
            res.status(400).json({ error: 'Failed to login' });
        }
    }
};

module.exports = userController;
