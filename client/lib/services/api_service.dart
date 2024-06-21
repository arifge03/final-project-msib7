import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;
  late String baseUrl;

  ApiService() {
    baseUrl = 'http://192.168.212.17:3000'; // URL backend
    _dio = Dio(BaseOptions(baseUrl: baseUrl)); // Inisialisasi Dio dengan baseUrl
  }

  Future<Response> loginUser(String username, String password) async {
    try {
      Response response = await _dio.post(
        '/api/users/login',
        data: {'username': username, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Response> registerUser(String username, String password) async {
    try {
      Response response = await _dio.post(
        '/api/users/register',
        data: {'username': username, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<Response> fetchProducts(String token) async {
    try {
      Response response = await _dio.get(
        '/api/products',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Response> createProduct(String token, Map<String, dynamic> productData) async {
    try {
      Response response = await _dio.post(
        '/api/products',
        data: productData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<Response> updateProduct(String token, int productId, Map<String, dynamic> productData) async {
    try {
      Response response = await _dio.put(
        '/api/products/$productId',
        data: productData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<Response> deleteProduct(String token, int productId) async {
    try {
      Response response = await _dio.delete(
        '/api/products/$productId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
