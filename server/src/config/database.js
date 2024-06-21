const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('storage_management', 'postgres', 'admin123', {
  host: 'localhost',
  dialect: 'postgres',
  define: {
    timestamps: false // Jika tidak menggunakan createdAt dan updatedAt
  }
});

module.exports = sequelize;