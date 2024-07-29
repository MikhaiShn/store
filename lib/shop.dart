import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop_home_main_page.dart';

import 'shop_journal.dart';
import 'shop_menu.dart';
import 'shop_tmz/shop_tmz.dart';
import 'shop_raw_materials/shopMaterials(Сырьё).dart';

class Shop extends StatefulWidget {
  final String token;

  const Shop({Key? key, required this.token}) : super(key: key);

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
          ShopMaterials(
            token: widget.token,
            checkCalculate: '',
            calculationID: '',
            modelsID: '',
            sizeID: '',
          ),
          ShopTMZ(
            token: widget.token,
            checkCalculate: 'default_value', // Укажите правильное значение
            calculationID: 'default_value', // Укажите правильное значение
            modelsID: 'default_value', // Укажите правильное значение
            sizeId: 'default_value', // Укажите правильное значение
          ),
          ShopMenu(),
        ],
      ),
      bottomNavigationBar: buildBottomNavigatorBar(
        context,
        _selectedIndex,
        _onItemTapped,
      ),
    );
  }
}
