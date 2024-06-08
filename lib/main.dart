import 'package:flutter/material.dart';
import 'package:shop_apllication_1/%D0%97%D0%B0%D0%BA%D0%B0%D0%B7%D1%8B/shopAllOrders.dart';
import 'package:shop_apllication_1/get.dart';
import 'package:shop_apllication_1/shopLogIn.dart';
import 'package:shop_apllication_1/shopProduct.dart';


void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShopProduct(),
    );
  }
}
