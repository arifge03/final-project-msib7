import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'product_form_page.dart';

class MainMenuPage extends StatefulWidget {
  final String token;
  final int userId;

  MainMenuPage({required this.token, required this.userId});

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  late Dio _dio;
  List<dynamic> _products = [];
  bool _isLoading = false;
  int _retryCount = 3;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.212.17:3000/api',
      headers: {'Authorization': 'Bearer ${widget.token}'},
    ));
    _fetchProducts();
  }

  void _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _dio.get('/products');

      if (response.statusCode == 200) {
        setState(() {
          _products = response.data;
        });
      } else {
        _showErrorSnackBar('Failed to fetch products: ${response.data}');
      }
    } catch (e) {
      if (_retryCount > 0 && e is DioError && e.response?.statusCode == 500) {
        _retryCount--;
        await Future.delayed(Duration(seconds: 2)); // Delay before retrying
        _fetchProducts();
      } else {
        _showErrorSnackBar('Error fetching products: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 159, 237),
      appBar: AppBar(title: Text('Main Menu')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateToProductForm(product);
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              Image.network(
                                product['image_url'] ?? 'https://via.placeholder.com/150',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://via.placeholder.com/150',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      product['name'] ?? '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Qty: ${product['qty'] ?? ''}'),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmation(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToProductForm(null); // Navigate to ProductFormPage for adding new product
                    },
                    child: Text('Add Product'),
                  ),
                ),
              ],
            ),
    );
  }

  void _navigateToProductForm(dynamic product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormPage(
          token: widget.token,
          userId: widget.userId,
          product: product,
        ),
      ),
    );

    if (result != null) {
      if (product == null) {
        // Jika produk baru dibuat, tambahkan ke daftar produk
        setState(() {
          _products.add(result);
        });
      } else {
        // Jika produk diperbarui, perbarui item dalam daftar produk
        setState(() {
          final index = _products.indexWhere((p) => p['id'] == result['id']);
          if (index != -1) {
            _products[index] = result;
          }
        });
      }
    }
  }

  void _showDeleteConfirmation(dynamic product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product['name']}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(product['id']);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      final response = await _dio.delete('/products/$productId');

      if (response.statusCode == 200) {
        _fetchProducts(); // Refresh product list after deletion
        _showSuccessSnackBar('Product deleted successfully!');
      } else {
        _showErrorSnackBar('Failed to delete product: ${response.data}');
      }
    } catch (e) {
      _showErrorSnackBar('Error deleting product: $e');
    }
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
