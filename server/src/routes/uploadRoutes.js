const express = require('express');
const path = require('path');
const upload = require('../config/multer');
const router = express.Router();

router.post('/upload', upload.single('image'), (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }
    
    const imagePath = path.join(__dirname, '/uploads', req.file.filename);
    res.json({ imagePath });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
