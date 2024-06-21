const multer = require('multer');

// Konfigurasi penyimpanan file
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './uploads/'); // Menyimpan file di folder uploads
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname); // Nama file disimpan dengan timestamp
  }
});

// Konfigurasi multer dengan storage
const upload = multer({storage: storage});

module.exports = upload;
