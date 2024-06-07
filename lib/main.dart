import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shop.dart';
import 'package:shop_apllication_1/shopAllOrders.dart';

import 'shopLogIn.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShopLogIn(),
    );
  }
}
