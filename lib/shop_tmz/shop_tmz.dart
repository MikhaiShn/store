import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals_file/tmz_modals.dart';
import 'package:shop_apllication_1/shop_tmz/tmz_detail_page.dart';

class ShopTMZ extends StatefulWidget {
  final String token;
  final String checkCalculate;
  final String calculationID;
  final String modelsID;
  final String sizeId;
  ShopTMZ(
      {Key? key,
      required this.token,
      required this.checkCalculate,
      required this.calculationID,
      required this.modelsID,
      required this.sizeId})
      : super(key: key);

  @override
  State<ShopTMZ> createState() => _ShopTMZState();
}

class _ShopTMZState extends State<ShopTMZ> {
  List<TmzManufacturer> tmzManufacturerClient = [];
  String? groupName;
  final tmzGroupNameController = TextEditingController();
  final newTMZGroupController = TextEditingController();

  Future<void> getTMZ() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/tmz/bin/$binClient'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        print('ТМЗ данные успешно получены');
        dynamic responseData = jsonDecode(response.body);
        List<TmzManufacturer> manufacturers;
        if (responseData is List) {
          manufacturers = responseData
              .map<TmzManufacturer>((json) => TmzManufacturer.fromJson(json))
              .toList();
        } else if (responseData is Map<String, dynamic>) {
          manufacturers = [TmzManufacturer.fromJson(responseData)];
        } else {
          print(
              'Ошибка: полученные данные не соответствуют ожидаемому формату');
          return;
        }
        setState(() {
          tmzManufacturerClient = manufacturers;
        });
        await savedTMZData(manufacturers);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении запроса: $error');
    }
  }

  Future<void> addMaterialCategory(String industryID) async {
    final url = Uri.parse(
        'https://baskasha-353162ef52af.herokuapp.com/tmz/$industryID/groups');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "groupName": tmzGroupNameController.text,
          "items":
              [] // Если требуется добавление элементов, их нужно добавить сюда
        }),
      );

      if (response.statusCode == 201) {
        print('Группа тмз добавлена успешно');
        await getTMZ();
        tmzGroupNameController.clear();
      } else {
        print('Ошибка при добавлении группы тмз: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении операции: $error');
    }
  }

  Future<void> updateGroupName(String industryID, String groupID) async {
    try {
      final response = await http.put(
        Uri.parse(
          'https://baskasha-353162ef52af.herokuapp.com/tmz/$industryID/groups/$groupID',
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
        await getTMZ();
      } else {
        print('Ошибка при изменении названия группы: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении операции: $error');
    }
  }

  Future<void> deleteRawGroup(String idIndustry, String groupID) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://baskasha-353162ef52af.herokuapp.com/tmz/$idIndustry/groups/$groupID'));
      if (response.statusCode == 200) {
        print('Группа успешно удалена');
        await getTMZ(); // Обновляем список после удаления
      } else {
        print('Ошибка при удалении группы: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении операции: $error');
    }
  }

  Future<void> savedTMZData(List<TmzManufacturer> manufacturers) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString =
          jsonEncode(manufacturers.map((e) => e.toJson()).toList());
      await prefs.setString('tmzData', jsonString);
      print('Данные ТМЗ сохранены в кеш');
    } catch (error) {
      print('Ошибка при сохранении данных: $error');
    }
  }

  Future<void> checkTMZData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('tmzData');
      if (jsonString != null) {
        List<dynamic> jsonResponse = jsonDecode(jsonString);
        List<TmzManufacturer> manufacturers =
            jsonResponse.map((e) => TmzManufacturer.fromJson(e)).toList();
        setState(() {
          tmzManufacturerClient = manufacturers;
        });
        print('Получены данные с кеша ТМЗ');
      } else {
        await getTMZ();
      }
    } catch (error) {
      print('Ошибка при загрузке данных: $error');
      await getTMZ();
    }
  }

  @override
  void initState() {
    super.initState();
    checkTMZData();
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
                                    child:
                                        Text('Добавить группу', style: textH1),
                                  ),
                                  buildTextFormField(
                                    'Новая группа',
                                    tmzGroupNameController,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (tmzManufacturerClient.isNotEmpty) {
                                          await addMaterialCategory(
                                              tmzManufacturerClient.first.id);
                                          Navigator.of(context).pop();
                                        } else {
                                          print(
                                              'Нет данных для добавления группы');
                                        }
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
        body: tmzManufacturerClient.isEmpty
            ? Center(
                child: Text('Нет данных'),
              )
            : ListView.builder(
                itemCount: tmzManufacturerClient.length,
                itemBuilder: (context, manufacturerIndex) {
                  TmzManufacturer tmzModal =
                      tmzManufacturerClient[manufacturerIndex];
                  return Column(
                    children: tmzModal.materials
                        .map((material) => Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  material.groupName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: material.items.isNotEmpty
                                    ? Icon(Icons.arrow_forward_ios)
                                    : null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          TmzDetail(
                                        token: widget.token,
                                        material: material.items,
                                        groupName: material.groupName,
                                        groupId: material.id,
                                        materialId: tmzModal.id,
                                        checkCalculate: widget.checkCalculate,
                                        calculationID: widget.calculationID,
                                        modelsID: widget.modelsID,
                                        sizeId: widget.sizeId,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(-1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ))
                        .toList(),
                  );
                }));
  }

  TextFormField buildTextFormField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
