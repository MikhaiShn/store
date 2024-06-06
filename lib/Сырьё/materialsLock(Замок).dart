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
      appBar: AppBar(
        title: Text('Замок'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Возврат на предыдущий экран
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
      floatingActionButton: buildAddButton(context, () {}),
    );
  }
}
