import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/tmzModal.dart';
import 'package:shop_apllication_1/tmzDetailPage.dart';

class ShopTMZ extends StatefulWidget {
  String token;
  ShopTMZ({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopTMZ> createState() => _ShopTMZState();
}

class _ShopTMZState extends State<ShopTMZ> {
  List<TMZModal> tmzManufacturerClient = [];
  String? groupName;
  Future<void> getTMZ() async {
    final response = await http.get(
      Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/bin/$binClient'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('ТМЗ данные успешно получены');
      List<dynamic> tmzManufacturerJson = jsonDecode(response.body);
      setState(() {
        // tmzManufacturerClient =
        //     tmzManufacturerJson;
      });
    } else {
      // Обработка ошибок запроса, например:
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> addTMZCategory() async {
    print('binClient $binClient');
    print('groupName ${tmzGroupNameController.text}');
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
            groupName, // Название группы сырья из контроллера
      }),
    );

    if (response.statusCode == 201) {
      print('Группа сырья добавлена успешно');
      // Выполнение каких-либо действий после успешного добавления
      getTMZ(); // Возможно, это ваш метод для получения обновленных данных
    tmzGroupNameController
          .clear(); // Очистка поля ввода названия группы сырья
    } else {
      print('Ошибка при добавлении группы сырья: ${response.statusCode}');
      // Обработка ошибок, если необходимо
    }
  }

  Future<void> deleteGroupTMZ() async {
print('Удаление группы началось');
  print(groupName);
  print(binClient);

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${widget.token}',
  };
  var request = http.Request(
      'DELETE',
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/group'));
  request.body = json.encode({
    'bin': binClient,
    'groupName': groupName,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  print(response.statusCode);
  if (response.statusCode == 200) {
    getTMZ();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заказ успешно удален')),
    );
  } else {
    print('Ошибка при удалении группы: ${response.reasonPhrase}');
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
        title: Center(child: Text('Товаро-материальный запас')),
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
                    groupName = keys;
                    List<MaterialTmz> tmzMaterialList =
                        tmzModal.materials[keys]!;
                    return Dismissible(
                      key: Key(keys),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        setState(() {
                          tmzModal.materials.remove(keys);
                        });
                        await deleteGroupTMZ();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$keys удален')),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TmzDetail(
                                  groupName: groupName,
                                  keys: keys,
                                  token: widget.token,
                                  material: tmzMaterialList,
                                  ),
                            ),
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
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
        // floatingActionButton:  FloatingActionButton(
        //         onPressed: () {
        //           showDialog(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return Dialog(
        //                 child: Stack(
        //                   children: [
        //                     Container(
        //                       width: MediaQuery.of(context).size.width *
        //                           0.9, // 90% of screen width
        //                       height: MediaQuery.of(context).size.height *
        //                           0.65, // 60% of screen height
        //                       padding: EdgeInsets.all(16.0),
        //                       child: SingleChildScrollView(
        //                         child: Column(
        //                           mainAxisSize: MainAxisSize.min,
        //                           children: [
        //                             SizedBox(height: 20),
        //                             Center(
        //                               child:
        //                                   Text('Добавить группу', style: textH1),
        //                             ),
        //                             Text(manufacturerIndustryName!),
        //                             buildTextFormField(
        //                                 'Новая группа', tmzGroupNameController),
        //                             Align(
        //                               alignment: Alignment.bottomCenter,
        //                               child: ElevatedButton(
        //                                 onPressed: () async {
        //                                   addTMZCategory();
        //                                   Navigator.of(context).pop();
        //                                 },
        //                                 child: Text('Добавить'),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                     Positioned(
        //                       right: 0.0,
        //                       top: 0.0,
        //                       child: IconButton(
        //                         icon: Icon(Icons.close),
        //                         onPressed: () {
        //                           addTMZCategory();
        //                           Navigator.of(context)
        //                               .pop(); // Закрыть диалоговое окно
        //                         },
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             },
        //           );
        //         },
        //         child: Icon(Icons.add),
        //       )
 
    );
  }
}
