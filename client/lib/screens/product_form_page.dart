import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ProductFormPage extends StatefulWidget {
  final String token;
  final int userId;
  final dynamic product;

  ProductFormPage({
    required this.token,
    required this.userId,
    this.product,
  });

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final Dio _dio = Dio();

  int? _selectedCategoryId;
  List<Category> _categoryItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _categoryItems = [
      Category(id: 1, name: 'Electronics'),
      Category(id: 2, name: 'Furniture'),
      Category(id: 3, name: 'Clothing'),
      Category(id: 4, name: 'Books'),
      Category(id: 5, name: 'Toys'),
    ];
    _selectedCategoryId = widget.product != null
        ? widget.product['category_id'] ?? _categoryItems.first.id
        : _categoryItems.first.id;

    if (widget.product != null) {
      _nameController.text = widget.product['name'];
      _qtyController.text = widget.product['qty']?.toString() ?? '';
      _imageUrlController.text = widget.product['image_url'] ?? '';
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final name = _nameController.text;
      final qty = int.tryParse(_qtyController.text) ?? 0;
      final imageUrl = _imageUrlController.text;
      final categoryId = _selectedCategoryId;

      final data = {
        'name': name,
        'qty': qty,
        'category_id': categoryId,
        'image_url': imageUrl,
        'created_by': widget.userId,
        'updated_by': widget.userId,
      };

      print('Request Data: $data');

      try {
        Response response;
        if (widget.product == null) {
          // Buat produk baru
          response = await _dio.post(
            'http://192.168.212.17:3000/api/products',
            data: data,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${widget.token}',
                'Content-Type': 'application/json',
              },
            ),
          );
          if (response.statusCode == 201) {
            print('Product created successfully: ${response.data}');
            Navigator.pop(context, response.data); // Return the created product data
            _showSuccessSnackBar('Product created successfully!');
          } else {
            print('Failed to create product: ${response.data}');
            _showErrorSnackBar('Failed to create product');
          }
        } else {
          // Perbarui produk yang ada
          response = await _dio.put(
            'http://192.168.212.17:3000/api/products/${widget.product['id']}',
            data: data,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${widget.token}',
                'Content-Type': 'application/json',
              },
            ),
          );
          if (response.statusCode == 200) {
            print('Product updated successfully: ${response.data}');
            Navigator.pop(context, response.data); // Return the updated product data
            _showSuccessSnackBar('Product updated successfully!');
          } else {
            print('Failed to update product: ${response.data}');
            _showErrorSnackBar('Failed to update product');
          }
        }
      } catch (e) {
        if (e is DioError) {
          print('DioError: ${e.response?.data}');
        } else {
          print('Error: $e');
        }
        _showErrorSnackBar('Error saving product');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Create Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items: _categoryItems.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  final urlPattern = r'^(http|https):\/\/([\w\-]+(\.[\w\-]+)+(:\d+)?(\/.*)?)$';
                  if (!RegExp(urlPattern, caseSensitive: false).hasMatch(value)) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text(widget.product == null ? 'Create Product' : 'Update Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}
