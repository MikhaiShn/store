import 'package:flutter/material.dart';
import 'package:shop_apllication_1/%D0%9A%D0%B0%D0%BB%D1%8C%D0%BA%D1%83%D0%BB%D1%8F%D1%86%D0%B8%D1%8F/shopCalculation.dart';
import 'package:shop_apllication_1/%D0%A1%D1%8B%D1%80%D1%8C%D1%91/shopMaterials(%D0%A1%D1%8B%D1%80%D1%8C%D1%91).dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shopProduct%20(%D0%93%D0%BE%D1%82%D0%BE%D0%B2%D0%B0%D1%8F%20%D0%BF%D1%80%D0%BE%D0%B4%D1%83%D0%BA%D1%86%D0%B8%D1%8F).dart';
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
  width: double.infinity,
  height: MediaQuery.of(context).size.height * 0.18,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Выравнивание по началу оси X
      children: [
        buildIcon(
          Icons.assignment,
          "Заказы",
          Colors.green,
          30,
          ShopAllOrders(token: token!),
          context,
        ),
        buildIcon(
          Icons.check_box,
          "   Готовая\nпродукция",
          Colors.green,
          30,
          ShopProduct(),
          context,
        ),
        buildIcon(
          Icons.add_alert,
          'Сырьё',
          Colors.green,
          30,
          ShopMaterials(
            token: token,
            checkCalculate: '',
            calculationID: '',
            modelsID: '',
            sizeID: '',
          ),
          context,
        ),
        buildIcon(
          Icons.calculate,
          "Калькуляция",
          Colors.green,
          30,
          ShopCalculation(token: token!),
          context,
        ),
      ],
    ),
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIcon(IconData iconData, String title, Color color, double size,
      Widget clazz, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => clazz));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: color,
            size: size,
          ),
          SizedBox(
              height: 8), // Добавим небольшой отступ между иконкой и текстом
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
