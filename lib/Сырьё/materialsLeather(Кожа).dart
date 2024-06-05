import 'package:flutter/material.dart';

import '../globals.dart';

class ShopMaterialsLeather extends StatefulWidget {
  const ShopMaterialsLeather({super.key});

  @override
  State<ShopMaterialsLeather> createState() => _ShopMaterialsLeatherState();
}

class _ShopMaterialsLeatherState extends State<ShopMaterialsLeather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarTitle('Кожа'),
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
