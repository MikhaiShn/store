import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop_auth.dart';
import 'shop_product/shop_product.dart';
import 'package:http/http.dart' as http;

class ShopMenu extends StatefulWidget {
  const ShopMenu({super.key});

  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(); // Вызываем метод для выхода
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopProduct()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Готовая продукция',
                  style: textH1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

void _logout() async{
  // Очищаем данные сессии
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');
  await prefs.remove('role');
  await prefs.remove('binClient');
  await prefs.remove('manufacturerIndustryName');

  print('token logout: $token');
  print('role: $role');
  print('bin: $binClient');
  
  // Перенаправляем пользователя на экран входа или другой начальный экран
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ShopLogIn()),
  );
}
}
