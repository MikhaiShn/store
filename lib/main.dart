import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shop.dart';

import 'shopLogIn(страница Авторизации).dart';




void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShopLogIn(),
    );
  }
}
