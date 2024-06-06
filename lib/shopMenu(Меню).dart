import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

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
          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}
