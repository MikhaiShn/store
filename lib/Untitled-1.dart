// import 'package:flutter/material.dart';
// import 'package:shop_apllication_1/globals.dart';
// import 'package:shop_apllication_1/shopAllOrders.dart';

// import 'shopJournal(Журнал).dart';
// import 'shopMenu.dart';
// import 'shopTMZ.dart';
// import 'Сырьё/shopMaterials(Сырьё).dart';

// class Shop extends StatefulWidget {
//   const Shop({super.key});

//   @override
//   State<Shop> createState() => _ShopState();
// }

// class _ShopState extends State<Shop> {
//   PageController _pageController = PageController(initialPage: 0);
//   int currentPage = 0;
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: FlexibleSpaceBar(
//           centerTitle: true,
//           title: Image.asset(
//             'assets1/logo.png',
//             fit: BoxFit.cover,
//             height: AppBar().preferredSize.height,
//           ),
//         ),
//         toolbarHeight: 80,
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Center(
//                   child: Text(
//                     'ТОО "Михаил"',
//                     style: textH1,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     constraints: BoxConstraints.expand(
//                         width: double.infinity, height: 100),
//                     decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.4),
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Center(
//                       child: Text('Сумма всего актива', style: textH1),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 80.0),
//                           child: Text(
//                             'Заказы',
//                             style: textH1,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ShopAllOrders()));
//                       },
//                       child: Text(
//                         'Все',
//                         style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black),
//                       ),
//                       style: ButtonStyle(
//                         fixedSize: MaterialStateProperty.resolveWith(
//                             (states) => Size(80, 16)),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         _pageController.animateToPage(0,
//                             duration: Duration(milliseconds: 500),
//                             curve: Curves.ease);
//                       },
//                       child: Text(
//                         'Выполненные',
//                         style: textH2,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         _pageController.animateToPage(1,
//                             duration: Duration(milliseconds: 500),
//                             curve: Curves.ease);
//                       },
//                       child: Text(
//                         'В обработке',
//                         style: textH2,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       height: 500,
//                       child: PageView(
//                         scrollDirection: Axis.horizontal,
//                         onPageChanged: (int page) {
//                           setState(() {
//                             currentPage = page;
//                           });
//                         },
//                         children: [
//                           Container(
//                             child: Column(
//                               children: [],
//                             ),
//                           ),
//                           Container(
//                             child: Column(
//                               children: [],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           ShopJournal(),
//           ShopMaterials(),
//           ShopTMZ(),
//           ShopMenu(),
//         ],
//       ),
//       bottomNavigationBar:
//           buildBottomNavigatorBar(context, _selectedIndex, _onItemTapped),
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
