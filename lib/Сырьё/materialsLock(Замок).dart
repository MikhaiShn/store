import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopMaterialsLock extends StatefulWidget {
  const ShopMaterialsLock({super.key});

  @override
  State<ShopMaterialsLock> createState() => _ShopMaterialsLockState();
}

class _ShopMaterialsLockState extends State<ShopMaterialsLock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarTitle('Замок'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
