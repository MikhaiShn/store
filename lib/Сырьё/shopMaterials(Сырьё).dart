import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_apllication_1/%D0%A1%D1%8B%D1%80%D1%8C%D1%91/ShopMaterialDetail.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/rawMaterialsModal.dart'; // импорт модели

class ShopMaterials extends StatefulWidget {
  final String? token;

  ShopMaterials({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopMaterials> createState() => _ShopMaterialsState();
}

class _ShopMaterialsState extends State<ShopMaterials> {
  TextEditingController newMaterials = TextEditingController();
  List<Manufacturer> manufacturerClient = []; // Список для хранения материалов

  Future<void> getMaterial() async {
    final response = await http.get(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/sklad/'),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );
    if (response.statusCode == 200) {
      List<dynamic> manufacturersJson = jsonDecode(response.body);
      setState(() {
        manufacturerClient = manufacturersJson
            .map((json) => Manufacturer.fromJson(json))
            .toList();
      });
    } else {
      // Обработка ошибок запроса, например:
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> addMaterialCategory() async {
    print('binClient $binClient');
    print('groupName $rawGroupNameController');
    
    final response = await http.post(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/sklad/group'),
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
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Группа сырья добавлена успешно');
      // Выполнение каких-либо действий после успешного добавления
      getMaterial(); // Возможно, это ваш метод для получения обновленных данных
      rawGroupNameController.clear(); // Очистка поля ввода названия группы сырья
    } else {
      print('Ошибка при добавлении группы сырья: ${response.statusCode}');
      // Обработка ошибок, если необходимо
    }
  }

  @override
  void initState() {
    super.initState();
    getMaterial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Светло-серый фон
      appBar: AppBar(
        title: Text('Сырьё'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: manufacturerClient.length,
        itemBuilder: (context, manufacturerIndex) {
          Manufacturer manufacturer = manufacturerClient[manufacturerIndex];
          List<String> categoryKeys = manufacturer.materials.keys.toList();

          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Производитель: ${manufacturer.manufacturerIndustry}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryKeys.map((key) {
                    List<RawMaterial> rawMaterialList =
                        manufacturer.materials[key]!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MaterialDetailPage(
                                  keys: key, rawMaterial: rawMaterialList, token: token, getMaterial: getMaterial(),)),
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
                          key,
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
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.9, // 90% of screen width
                            height: MediaQuery.of(context).size.height *
                                0.65, // 60% of screen height
                            padding: EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                    child:
                                        Text('Добавить группу', style: textH1),
                                  ),
                                  Text(manufacturerIndustryName!),
                                  buildTextFormField(
                                      'Новая группа', rawGroupNameController),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await addMaterialCategory(); // Добавить заказ
                                        Navigator.of(context).pop();
                                        await getMaterial();
                                      },
                                      child: Text('Добавить'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Закрыть диалоговое окно
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
    );
  }


}
