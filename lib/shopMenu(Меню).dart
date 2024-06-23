import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shopLogIn(%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0%20%D0%90%D0%B2%D1%82%D0%BE%D1%80%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8).dart';
import 'package:shop_apllication_1/shopProductManager.dart';
import 'shopProduct (Готовая продукция).dart';

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
                  MaterialPageRoute(builder: (context) => ShopProductManager()),
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

void _logout() {
  // Очищаем данные сессии
  token = null;
  role = null;
  binClient = null;
  manufacturerIndustryName = null;

  print('token logout: $token');
  print('role: $role');
  print('bin: $binClient');

  // Перенаправляем пользователя на экран входа или другой начальный экран
  // Navigator.pushReplacement(
  //   context,
  //   // MaterialPageRoute(builder: (context) => ShopLogIn(prefs: null,)),
  // );
}
}
