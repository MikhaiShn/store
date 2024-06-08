import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/%D0%97%D0%B0%D0%BA%D0%B0%D0%B7%D1%8B/shopAllOrders.dart';

class ShopHome extends StatefulWidget {
  const ShopHome({Key? key}) : super(key: key);

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          buildSliverAppbar(' '),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: BoxConstraints.expand(
                        width: double.infinity, height: 100),
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text('Сумма всего актива', style: textH1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 80.0),
                          child: Text(
                            'Заказы',
                            style: textH1,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopAllOrders()));
                      },
                      child: Text(
                        'Все',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.resolveWith(
                            (states) => Size(80, 16)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Text(
                        'Выполненные',
                        style: textH2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Text(
                        'В обработке',
                        style: textH2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Container(
                      height: 500,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (int page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        children: [
                          Container(
                            child: Column(
                              children: [],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              height: 500,
            ), // Замените Placeholder() на ваш реальный контент
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
