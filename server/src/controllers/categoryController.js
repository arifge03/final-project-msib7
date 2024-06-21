const Category = require('../models/category');

const categoryController = {
    async getAllCategories(req, res) {
        try {
            const categories = await Category.findAll();
            res.json(categories);
        } catch (error) {
            res.status(400).json({ error: error.message });
        }
    }
};

module.exports = categoryController;