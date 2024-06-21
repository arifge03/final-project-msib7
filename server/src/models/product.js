const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize('storage_management', 'postgres', 'admin123', {
  host: 'localhost',
  dialect: 'postgres',
  define: {
    timestamps: false // Jika tidak menggunakan createdAt dan updatedAt
  }
});

const Product = sequelize.define('Product', {
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  qty: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  category_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  image_url: {
    type: DataTypes.STRING
  },
  created_by: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  updated_by: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'products' // Optional: nama tabel di database
});

module.exports = Product;
