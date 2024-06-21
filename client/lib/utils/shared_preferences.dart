import 'package:shared_preferences/shared_preferences.dart';

// Simpan token
Future<void> saveToken(String token) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  } catch (e) {
    print('Failed to save token: $e');
    throw Exception('Failed to save token');
  }
}

// Ambil token
Future<String?> getToken() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  } catch (e) {
    print('Failed to get token: $e');
    throw Exception('Failed to get token');
  }
}

// Hapus token (untuk logout)
Future<void> removeToken() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  } catch (e) {
    print('Failed to remove token: $e');
    throw Exception('Failed to remove token');
  }
}
