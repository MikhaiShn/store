import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_apllication_1/methods/methodGalery.dart';
import 'package:shop_apllication_1/shop.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Shop(),
    );
  }
}
