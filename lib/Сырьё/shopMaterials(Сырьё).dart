import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_apllication_1/Сырьё/ShopMaterialDetail.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/rawMaterialsModal.dart';

class ShopMaterials extends StatefulWidget {
  final String? token;

  ShopMaterials({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopMaterials> createState() => _ShopMaterialsState();
}

class _ShopMaterialsState extends State<ShopMaterials> {
  TextEditingController newMaterials = TextEditingController();
  List<Manufacturer> manufacturerClient = []; // Список для хранения материалов
  String? selectedMaterialId; // Переменная для сохранения _id выбранного материала
  String? groupID; //Хранение id группы

  Future<void> getMaterial() async {
    final response = await http.get(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/bin/$binClient'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      print('Сырье получено успешно');
      dynamic responseData = jsonDecode(response.body);

      // Проверяем тип данных
      if (responseData is List) {
        // Преобразуем каждый элемент в объект типа Manufacturer
        List<Manufacturer> manufacturers = responseData
            .map<Manufacturer>((json) => Manufacturer.fromJson(json))
            .toList();

        setState(() {
          manufacturerClient = manufacturers;
        });
      } else if (responseData is Map<String, dynamic>) {
        // Если вернулся один объект, а не список, можно обработать его как один объект
        Manufacturer manufacturer = Manufacturer.fromJson(responseData);
        setState(() {
          manufacturerClient = [manufacturer];
        });
        selectedMaterialId = manufacturer.id; // Предполагается, что у Manufacturer есть поле id
      } else {
        print('Ошибка: полученные данные не соответствуют ожидаемому формату');
      }
    } else {
      // Обработка ошибок запроса, например:
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> deletRawGroup() async {
    final response = await http.delete(Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/$selectedMaterialId/groups/$groupID'));
    if (response.statusCode == 200) {
      print('Группа успешно удалена из сырья');
    }
  }

  Future<void> addMaterialCategory() async {
    final url = Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/$selectedMaterialId/groups');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "groupName": rawGroupNameController.text,
          "items": [] // Если требуется добавление элементов, их нужно добавить сюда
        }),
      );

      if (response.statusCode == 201) {
        print('Группа сырья добавлена успешно');
        // Выполнение каких-либо действий после успешного добавления
        getMaterial(); // Возможно, это ваш метод для получения обновленных данных
        rawGroupNameController
            .clear(); // Очистка поля ввода названия группы сырья
      } else {
        print('Ошибка при добавлении группы сырья: ${response.statusCode}');
        // Обработка ошибок, если необходимо
      }
    } catch (error) {
      print('Ошибка при выполнении операции: $error');
      // Обработка ошибок, если необходимо
    }
  }

  Future<void> updateGroupName() async {
    final response = await http.put(
      Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/$selectedMaterialId/groups/$groupID',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        "groupName": newRawGroupController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Название группы успешно изменено');
      getMaterial();
    } else {
      print('Ошибка при изменении названия группы: ${response.statusCode}');
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Сырьё'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: manufacturerClient.length,
        itemBuilder: (context, manufacturerIndex) {
          Manufacturer manufacturer = manufacturerClient[manufacturerIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: manufacturer.materials.map((materialGroup) {
              groupID = materialGroup.id;
              return Dismissible(
                key: Key(materialGroup.id),
                confirmDismiss: (direction) async {
                  await deletRawGroup();
                  return true;
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return Dialog(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              height: MediaQuery.sizeOf(context).height * 0.2,
                              child: Column(
                                children: [
                                  buildTextFormField('Новое название группы',
                                      newRawGroupController),
                                  ElevatedButton(
                                      onPressed: () {
                                        updateGroupName();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Изменить'))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaterialDetailPage(
                          token: widget.token,
                          getMaterial: getMaterial,
                          groupName: materialGroup.groupName,
                          rawMaterial: materialGroup.items,
                          idIndustry: selectedMaterialId!,
                          idGroup: materialGroup.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Группа сырья: ${materialGroup.groupName}', // Отображаем название группы материала
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Количество элементов: ${materialGroup.items.length}', // Отображаем количество элементов в группе
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.65,
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text('Добавить группу', style: textH1),
                            ),
                            buildTextFormField(
                              'Новая группа',
                              rawGroupNameController,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await addMaterialCategory();
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
                          Navigator.of(context).pop();
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
      ),
    );
  }
}
