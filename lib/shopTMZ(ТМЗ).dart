import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/rawMaterialsModal.dart';
import 'package:shop_apllication_1/modals/tmzModal.dart';
import 'package:shop_apllication_1/tmzDetailPage.dart';

class ShopTMZ extends StatefulWidget {
  String token;
   ShopTMZ({super.key, required this.token});

  @override
  State<ShopTMZ> createState() => _ShopTMZState();
}

class _ShopTMZState extends State<ShopTMZ> {
  List<TMZModal> tmzManufacturerClient = [];
  
  Future<void> getTMZ() async {
    final response = await http.get(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      print('Данные успешно получены');
      print(response.statusCode);
      List<dynamic> tmzManufacturerJson = jsonDecode(response.body);
      setState(() {
        tmzManufacturerClient = tmzManufacturerJson
            .map((json) => TMZModal.fromJson(json))
            .toList();
      });
    } else {
      // Обработка ошибок запроса, например:
      print('Failed to fetch data: ${response.statusCode}');
    }
  }
  
  Future<void> addTMZCategory() async {
    print('binClient $binClient');
    print('groupName $rawGroupNameController');
    final response = await http.post(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/group'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'bin':
            binClient, // Предположим, что binClient - это ваша переменная или значение BIN
        'manufacturerIndustry':
            manufacturerIndustryName, // Предположим, что это ваше значение отрасли производства
        'groupName':
            rawGroupNameController.text, // Название группы сырья из контроллера
      }),
    );

    if (response.statusCode == 201) {
      print('Группа сырья добавлена успешно');
      // Выполнение каких-либо действий после успешного добавления
      getTMZ(); // Возможно, это ваш метод для получения обновленных данных
      rawGroupNameController.clear(); // Очистка поля ввода названия группы сырья
    } else {
      print('Ошибка при добавлении группы сырья: ${response.statusCode}');
      // Обработка ошибок, если необходимо
    }
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTMZ();
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Светло-серый фон
      appBar: AppBar(
        title: Text('ТМз'),
        backgroundColor: Colors.blue,

      ),
      body: ListView.builder(
        itemCount: tmzManufacturerClient.length,
        itemBuilder: (context, manufacturerIndex) {
          TMZModal tmzModal = tmzManufacturerClient[manufacturerIndex];
          List<String> categoryKeys = tmzModal.materials.keys.toList();

          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Производитель: ${tmzModal.manufacturerIndustry}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryKeys.map((keys) {
                    List<MaterialTmz> tmzMaterialList =
                        tmzModal.materials[keys]!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TmzDetailPage(keys: keys, token: widget.token, material: tmzMaterialList,getTMZ: getTMZ(),)),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          keys,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    //   floatingActionButton:  FloatingActionButton(
    //           onPressed: () {
    //             showDialog(
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return Dialog(
    //                   child: Stack(
    //                     children: [
    //                       Container(
    //                         width: MediaQuery.of(context).size.width *
    //                             0.9, // 90% of screen width
    //                         height: MediaQuery.of(context).size.height *
    //                             0.65, // 60% of screen height
    //                         padding: EdgeInsets.all(16.0),
    //                         child: SingleChildScrollView(
    //                           child: Column(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               SizedBox(height: 20),
    //                               Center(
    //                                 child:
    //                                     Text('Добавить группу', style: textH1),
    //                               ),
    //                               Text(manufacturerIndustryName!),
    //                               buildTextFormField(
    //                                   'Новая группа', rawGroupNameController),
    //                               Align(
    //                                 alignment: Alignment.bottomCenter,
    //                                 child: ElevatedButton(
    //                                   onPressed: () async {
    //                                     addTMZCategory();
    //                                     Navigator.of(context).pop();
    //                                   },
    //                                   child: Text('Добавить'),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       Positioned(
    //                         right: 0.0,
    //                         top: 0.0,
    //                         child: IconButton(
    //                           icon: Icon(Icons.close),
    //                           onPressed: () {
    //                             addTMZCategory(); 
    //                             Navigator.of(context)
    //                                 .pop(); // Закрыть диалоговое окно
    //                           },
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               },
    //             );
    //           },
    //           child: Icon(Icons.add),
    //         )
     );
  }

}
