import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_apllication_1/Сырьё/ShopMaterialDetail.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/rawMaterialsModal.dart';

class ShopMaterials extends StatefulWidget {
  final String? token;
  final String? checkCalculate;
  final String? calculationID;
  final String modelsID;
  final String? sizeID;
  ShopMaterials(
      {Key? key,
      required this.token,
      required this.checkCalculate,
      required this.calculationID,
      required this.modelsID,
      required this.sizeID})
      : super(key: key);

  @override
  State<ShopMaterials> createState() => _ShopMaterialsState();
}

class _ShopMaterialsState extends State<ShopMaterials> {
  TextEditingController newMaterials = TextEditingController();
  List<Manufacturer> manufacturerClient = []; // Список для хранения материалов

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

      if (responseData is List) {
        List<Manufacturer> manufacturers = responseData
            .map<Manufacturer>((json) => Manufacturer.fromJson(json))
            .toList();
        setState(() {
          manufacturerClient = manufacturers;
        });
      } else if (responseData is Map<String, dynamic>) {
        Manufacturer manufacturer = Manufacturer.fromJson(responseData);
        setState(() {
          manufacturerClient = [manufacturer];
        });
      } else {
        print('Ошибка: полученные данные не соответствуют ожидаемому формату');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> deletRawGroup(String selectedMaterialId, String groupID) async {
    final response = await http.delete(Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/$selectedMaterialId/groups/$groupID'));
    if (response.statusCode == 200) {
      print('Группа успешно удалена из сырья');
      await getMaterial(); // Обновляем данные после удаления
    }
  }

  Future<void> addMaterialCategory(String selectedMaterialId) async {
    final url = Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/raw/$selectedMaterialId/groups');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body:
            jsonEncode({"groupName": rawGroupNameController.text, "items": []}),
      );

      if (response.statusCode == 201) {
        print('Группа сырья добавлена успешно');
        await getMaterial(); // Обновляем данные после добавления
        rawGroupNameController
            .clear(); // Очистка поля ввода названия группы сырья
      } else {
        print('Ошибка при добавлении группы сырья: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении операции: $error');
    }
  }

  Future<void> updateGroupName(
      String selectedMaterialId, String groupID) async {
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
      await getMaterial(); // Обновляем данные после изменения названия
    } else {
      print('Ошибка при изменении названия группы: ${response.statusCode}');
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
        title: Center(child: Text('Сырьё')),
        backgroundColor: Colors.grey[100],
      ),
      body: ListView.builder(
        itemCount: manufacturerClient.length,
        itemBuilder: (context, manufacturerIndex) {
          Manufacturer manufacturer = manufacturerClient[manufacturerIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: manufacturer.materials.map((materialGroup) {
              return Dismissible(
                key: Key(materialGroup.id),
                confirmDismiss: (direction) async {
                  await deletRawGroup(manufacturer.id, materialGroup.id);
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
                                        updateGroupName(
                                            manufacturer.id, materialGroup.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Изменить'))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  onTap: () {},
                  child: widget.checkCalculate == 'Калькуляция'
                      ? Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6, // Более выраженная тень
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Группа сырья: ${materialGroup.groupName}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Количество элементов: ${materialGroup.items.length}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween =
                                              Tween(begin: begin, end: end);
                                          var offsetAnimation = animation.drive(
                                              tween.chain(
                                                  CurveTween(curve: curve)));
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: MaterialDetailPage(
                                              token: widget.token,
                                              getMaterial: getMaterial,
                                              groupName:
                                                  materialGroup.groupName,
                                              rawMaterial: materialGroup.items,
                                              idIndustry: manufacturer.id,
                                              idGroup: materialGroup.id,
                                              checkCalculate:
                                                  widget.checkCalculate!,
                                              calculationID:
                                                  widget.calculationID,
                                              modelsID: widget.modelsID,
                                              sizeID: widget.sizeID,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_forward_ios),
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4, // Тень под картой
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Группа сырья: ${materialGroup.groupName}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Количество элементов: ${materialGroup.items.length}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 10),
                                // Добавление кнопки или дополнительного элемента
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOut;

                                            var tween =
                                                Tween(begin: begin, end: end);
                                            var offsetAnimation =
                                                animation.drive(tween.chain(
                                                    CurveTween(curve: curve)));
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: MaterialDetailPage(
                                                token: widget.token,
                                                getMaterial: getMaterial,
                                                groupName:
                                                    materialGroup.groupName,
                                                rawMaterial:
                                                    materialGroup.items,
                                                idIndustry: manufacturer.id,
                                                idGroup: materialGroup.id,
                                                checkCalculate:
                                                    widget.checkCalculate!,
                                                calculationID:
                                                    widget.calculationID,
                                                modelsID: widget.modelsID,
                                                sizeID: widget.sizeID,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Подробнее'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
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
    );
  }
}
