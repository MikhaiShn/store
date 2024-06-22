import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/sjopProductManager.dart';

class ShopMenu extends StatefulWidget {
  const ShopMenu({super.key});

  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildSliverAppbar('Меню'),
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
                  overflow: TextOverflow.ellipsis, // Обрезка текста с многоточием
                  maxLines: 1, // Максимальное количество строк (1 строка)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

