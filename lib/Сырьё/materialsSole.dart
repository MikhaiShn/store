import 'package:flutter/material.dart';

import '../globals.dart';

class ShopMaterialsSole extends StatefulWidget {
  const ShopMaterialsSole({super.key});

  @override
  State<ShopMaterialsSole> createState() => _ShopMaterialsSoleState();
}

class _ShopMaterialsSoleState extends State<ShopMaterialsSole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarTitle('Подошва'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [ElevatedButton(onPressed: () {}, child: Text(''))],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
