const express = require('express');
const cors = require('cors');
const userRoutes = require('./routes/userRoutes');
const productRoutes = require('./routes/productRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const uploadRoutes = require('./routes/uploadRoutes');
const authMiddleware = require('./middlewares/auth');
const path = require('path');

const app = express();

const corsOptions = {
  origin: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Izinkan metode HTTP ini
  allowedHeaders: ['Content-Type', 'Authorization'], // Izinkan header ini
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/users', userRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/products', authMiddleware, productRoutes);
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/api', uploadRoutes);

module.exports = app;
