import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shopeHome.dart';

import 'shopJournal(Журнал).dart';
import 'shopMenu(Меню).dart';
import 'shopTMZ(ТМЗ).dart';
import 'Сырьё/shopMaterials(Сырьё).dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required String token});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ShopHome(),
          ShopJournal(),
          ShopMaterials(),
          ShopTMZ(),
          ShopMenu(),
        ],
      ),
      bottomNavigationBar:
          buildBottomNavigatorBar(context, _selectedIndex, _onItemTapped),
    );
  }
}
