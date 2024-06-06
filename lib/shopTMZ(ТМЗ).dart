import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopTMZ extends StatefulWidget {
  const ShopTMZ({super.key});

  @override
  State<ShopTMZ> createState() => _ShopTMZState();
}

class _ShopTMZState extends State<ShopTMZ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildSliverAppbar('ТМЗ'),
          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}
