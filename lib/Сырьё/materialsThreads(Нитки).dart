import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';

class ShopMaterialsThreads extends StatefulWidget {
  const ShopMaterialsThreads({super.key});

  @override
  State<ShopMaterialsThreads> createState() => _ShopMaterialsThreadsState();
}

class _ShopMaterialsThreadsState extends State<ShopMaterialsThreads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarTitle('Нитки'),
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
