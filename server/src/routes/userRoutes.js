const express = require('express');
const userController = require('../controllers/userController');
const upload = require('../config/multer');
const router = express.Router();

// Route untuk register dengan upload gambar
router.post('/register', upload.single('image'), async (req, res, next) => {
  try {
    const { username, password } = req.body;
    if (!username || !password) {
      return res.status(400).json({ error: 'Username dan password harus diisi' });
    }

    await userController.register(req, res);
  } catch (error) {
    next(error);
  }
});

// Route untuk login
router.post('/login', async (req, res, next) => {
  try {
    await userController.login(req, res);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
