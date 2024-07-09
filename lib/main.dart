import 'package:flutter/material.dart';

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
