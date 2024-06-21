import 'package:flutter/material.dart';
import 'package:client/screens/login_page.dart';
import 'package:client/screens/register_page.dart';
import 'package:client/screens/main_menu_page.dart';
import 'package:client/screens/product_form_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String?;
          if (token == null) {
            return Scaffold(
              body: Center(
                child: Text('Token not found'),
              ),
            );
          }
          final userId = 0;
          return MainMenuPage(token: token, userId: userId);
        },
        '/product_form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
          final token = args['token'] as String?;
          final product = args['product'];
          final userId = args['userId'] as int?;
          if (token == null) {
            return Scaffold(
              body: Center(
                child: Text('Token not found'),
              ),
            );
          }
          return ProductFormPage(token: token, userId: userId ?? 0, product: product);
        },
      },
    );
  }
}
