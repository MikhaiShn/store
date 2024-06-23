import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop.dart';
import 'package:shop_apllication_1/shopProductManager.dart';

import 'Заказы/shopAllOrders.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: <Widget>[
          buildSliverAppbar(manufacturerIndustryName!),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 150,
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildPageViewContainer('Сумма всего актива',
                          Color.fromARGB(255, 159, 243, 166)),
                      buildPageViewContainer(
                          'Активы на реализации', Colors.grey.withOpacity(0.4))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildIcon(
                              Icons.assignment, "Заказы", Colors.green, 30,ShopAllOrders(token: token!),context),
                              buildIcon(
                              Icons.check_box, "   Готовая\nпродукция", Colors.green, 30,ShopProductManager(),context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



Widget buildIcon(IconData iconData, String title, Color color, double size, Widget clazz, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => clazz));
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: color,
          size: size,
        ),
        SizedBox(height: 8), // Добавим небольшой отступ между иконкой и текстом
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
