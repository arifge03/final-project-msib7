const jwt = require('jsonwebtoken');
const Product = require('../models/product');
const User = require('../models/user');

// Fungsi untuk menampilkan semua produk
exports.getAllProducts = async (req, res) => {
    try {
        const products = await Product.findAll();
        res.json(products);
    } catch (error) {
        console.error('Error fetching products:', error);
        res.status(500).json({ error: 'Failed to fetch products' });
    }
};

// Fungsi untuk menampilkan satu produk berdasarkan ID
exports.getProductById = async (req, res) => {
    const { id } = req.params;
    try {
        const product = await Product.findByPk(id);
        if (product) {
            res.json(product);
        } else {
            res.status(404).json({ error: 'Product not found' });
        }
    } catch (error) {
        console.error(`Error fetching product with id ${id}:`, error);
        res.status(500).json({ error: 'Failed to fetch product' });
    }
};

exports.createProduct = async (req, res) => {
    const { name, qty, category_id, image_url } = req.body;
    const created_by = req.userId; 

    try {
        if (!name || !qty || !category_id || !image_url || !created_by) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        const urlPattern = /^(http|https):\/\/[^\s$.?#].[^\s]*$/gm;
        if (!urlPattern.test(image_url)) {
            return res.status(400).json({ error: 'Invalid image URL' });
        }

        const user = await User.findByPk(created_by);

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Buat produk baru dengan created_by yang valid
        const newProduct = await Product.create({
            name,
            qty,
            category_id,
            image_url,
            created_by: user.id,
            updated_by: user.id,
        });

        res.status(201).json(newProduct);
    } catch (error) {
        console.error('Error creating product:', error);
        res.status(500).json({ error: 'Failed to create product' });
    }
};


// Fungsi untuk mengupdate produk berdasarkan ID
exports.updateProduct = async (req, res) => {
    const { id } = req.params;
    const { name, qty, category_id, image_url, updated_by } = req.body;
    try {
        let product = await Product.findByPk(id);
        if (product) {
            product = await product.update({
                name: name || product.name,
                qty: qty || product.qty,
                category_id: category_id || product.category_id,
                image_url: image_url || product.image_url,
                updated_by: updated_by || product.updated_by,
                update_date: new Date(),
            });
            res.json(product);
        } else {
            res.status(404).json({ error: 'Product not found' });
        }
    } catch (error) {
        console.error(`Error updating product with id ${id}:`, error);
        res.status(500).json({ error: 'Failed to update product' });
    }
};

// Fungsi untuk menghapus produk berdasarkan ID
exports.deleteProduct = async (req, res) => {
    const { id } = req.params;
    try {
        const product = await Product.findByPk(id);
        if (product) {
            await product.destroy();
            res.json({ message: 'Product deleted successfully' });
        } else {
            res.status(404).json({ error: 'Product not found' });
        }
    } catch (error) {
        console.error(`Error deleting product with id ${id}:`, error);
        res.status(500).json({ error: 'Failed to delete product' });
    }
};
