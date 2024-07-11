import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/tmzModal.dart';
import 'package:shop_apllication_1/tmzDetailPage.dart';

class ShopTMZ extends StatefulWidget {
  final String token;
  ShopTMZ({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopTMZ> createState() => _ShopTMZState();
}

class _ShopTMZState extends State<ShopTMZ> {
  List<TmzManufacturer> tmzManufacturerClient = [];
  String? groupName;
  String? materialId;
  String? groupID;

  Future<void> getTMZ() async {
    final response = await http.get(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/bin/$binClient'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (response.statusCode == 200) {
      print('ТМЗ данные успешно получены');
      dynamic responseData = jsonDecode(response.body);
      if (responseData is List) {
        List<TmzManufacturer> manufacturers = responseData
            .map<TmzManufacturer>((json) => TmzManufacturer.fromJson(json))
            .toList();

        setState(() {
          tmzManufacturerClient = manufacturers;
        });
      } else if (responseData is Map<String, dynamic>) {
        TmzManufacturer manufacturer = TmzManufacturer.fromJson(responseData);

        setState(() {
          tmzManufacturerClient = [manufacturer];
        });
      } else {
        print('Ошибка: полученные данные не соответствуют ожидаемому формату');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> addMaterialCategory() async {
    final url = Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/$materialId/groups');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "groupName": tmzGroupNameController.text,
          "items": [] // Если требуется добавление элементов, их нужно добавить сюда
        }),
      );

      if (response.statusCode == 201) {
        print('Группа тмз добавлена успешно');
        getTMZ(); 
        tmzGroupNameController.clear();
      } else {
        print('Ошибка при добавлении группы тмз: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении операции: $error');
    }
  }

  Future<void> updateGroupName() async {
    final response = await http.put(
      Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/$materialId/groups/$groupID',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        "groupName": newTMZGroupController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Название группы успешно изменено');
      getTMZ();
    } else {
      print('Ошибка при изменении названия группы: ${response.statusCode}');
    }
  }

  Future<void> deleteRawGroup() async {
    final response = await http.delete(Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/$materialId/groups/$groupID'));
    if (response.statusCode == 200) {
      print('Группа успешно удалена');
    } else {
      print('Ошибка при удалении группы: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTMZ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Товарно-материальный запас'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
                                  tmzGroupNameController,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await addMaterialCategory();
                                      Navigator.of(context).pop();
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
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tmzManufacturerClient.length,
        itemBuilder: (context, manufacturerIndex) {
          TmzManufacturer tmzModal = tmzManufacturerClient[manufacturerIndex];
          materialId = tmzModal.id;

          return Column(
            children: tmzModal.materials.map((material) {
              groupID = material.id;
              return Dismissible(
                key: Key(material.id),
                confirmDismiss: (direction) async {
                  await deleteRawGroup();
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Column(
                              children: [
                                buildTextFormField(
                                  'Новое название группы',
                                  newTMZGroupController,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    updateGroupName();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Изменить'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                TmzDetail(
                          token: widget.token,
                          material: material.items,
                          groupName: material.groupName,
                          groupId: groupID,
                          materialId: materialId,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(-1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(material.groupName),
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