import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shopRegistr.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShopRegister()
    );
  }
}
