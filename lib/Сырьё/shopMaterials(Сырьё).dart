import 'package:flutter/material.dart';
import 'package:shop_apllication_1/%D0%A1%D1%8B%D1%80%D1%8C%D1%91/materialsLaces(%D0%A8%D0%BD%D1%83%D1%80%D0%BA%D0%B8).dart';
import 'package:shop_apllication_1/globals.dart';
import 'materialsLeather(Кожа).dart';
import 'materialsLock(Замок).dart';
import 'materialsSole(Подошва).dart';
import 'materialsThreads(Нитки).dart';

class ShopMaterials extends StatefulWidget {
  const ShopMaterials({super.key});

  @override
  State<ShopMaterials> createState() => _ShopMaterialsState();
}

class _ShopMaterialsState extends State<ShopMaterials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          buildSliverAppbar('Сырьё'),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                child: Column(
                  children: [
                    buildContainerMaterials(
                        'Кожа', context, ShopMaterialsLeather()),
                    buildContainerMaterials(
                        'Шнурок', context, ShopMaterialsLaces()),
                    buildContainerMaterials(
                        'Подошва', context, ShopMaterialsSole()),
                    buildContainerMaterials(
                        'Замок', context, ShopMaterialsLock()),
                    buildContainerMaterials(
                        'Нить', context, ShopMaterialsThreads()),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: buildAddButton(context, () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      //bottomNavigationBar: buildBottomNavigatorBar(context),
    );
  }
}
