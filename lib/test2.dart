// import 'package:flutter/material.dart';


// class PageViewExample extends StatelessWidget {
//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: [
//           PageOne(),
//           PageTwo(),
//         ],
//       ),
//     );
//   }
// }
// {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MaterialDetailPage(
//                                   keys: key, rawMaterial: rawMaterialList, token: token,)) ,
//                         );
//                       },
// class PageOne extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page One')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: List.generate(
//             20,
//             (index) => Container(
//               height: 100,
//               color: index.isEven ? Colors.blue : Colors.green,
//               margin: EdgeInsets.all(8.0),
//               child: Center(
//                 child: Text(
//                   'Item $index',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PageTwo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page Two')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: List.generate(
//             20,
//             (index) => Container(
//               height: 100,
//               color: index.isEven ? Colors.red : Colors.yellow,
//               margin: EdgeInsets.all(8.0),
//               child: Center(
//                 child: Text(
//                   'Item $index',
//                   style: TextStyle(color: Colors.black, fontSize: 18),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// Future<void> addRawMaterial() async {
//   print('Вызван метод addRawMaterial'); // Проверяем вызов метода

//   // Создание объекта rawMaterialData из значений контроллеров
//   Map<String, dynamic> rawMaterialData = {
//     "itemRawName": itemRawNameController.text,
//     "selerBIN": selerBINController.text,
//     "selerRawContact": selerRawContactController.text,
//     "selerRawCountry": selerRawCountryController.text,
//     "import": true, // Пример преобразования в boolean
//     "codeitem": codeitemController.text,
//     "rawSezon": rawSezonController.text,
//     "rawModel": rawModelController.text,
//     "rawComment": rawCommentController.text,
//     "rawPerson": rawPersonController.text,
//     "rawSize": rawSizeController.text,
//     "rawColor": rawColorController.text,
//     "rawExpiryDate": '2026-12-31T00:00:00.000Z', // Убедитесь, что формат даты соответствует ожиданиям сервера
//     "rawQuantity": int.parse(rawQuantityController.text),
//     "rawUnit": rawUnitController.text,
//     "rawPurchaseprice": int.parse(rawPurchasepriceController.text),
//     "rawSellingprice": int.parse(rawSellingpriceController.text),
//   };

//   print('Данные для отправки на сервер: $rawMaterialData'); // Проверяем данные для отправки

//   // Создание POST запроса
//   final response = await http.post(
//     Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/sklad/raw'),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'bin': binClient,
//       'manufacturerIndustry': manufacturerIndustryName, // Проверьте, откуда берется значение manufacturerIndustryName
//       'item': 'Сырье', // Если значение всегда "Сырье"
//       'materials': [
//         rawMaterialData, // Помещаем данные сырья в массив materials
//       ],
//     }),
//   );

//   // Обработка ответа
//   if (response.statusCode == 201) {
//     print('Материал успешно добавлен');
//     final responseBody = jsonDecode(response.body);
//     // Можно дополнительно обработать ответ сервера, если это необходимо
//   } else {
//     print('Ошибка при добавлении материала: ${response.statusCode}');
//     // Обработка ошибки
//   }
// }