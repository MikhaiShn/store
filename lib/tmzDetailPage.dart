import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/tmzModal.dart';

import 'package:shop_apllication_1/globals.dart';

class TmzDetail extends StatefulWidget {
  final String? groupName;
  final String? keys;
  final String? token;
  final List<MaterialTmz> material;

  const TmzDetail({
    Key? key,
    required this.keys,
    required this.token,
    required this.material,
    required this.groupName,
  }) : super(key: key);

  @override
  State<TmzDetail> createState() => _TmzDetailState();
}

class _TmzDetailState extends State<TmzDetail> {
  List<TMZModal> tmzManufacturerClient = [];
  bool _isLoading = false; // Флаг для отслеживания загрузки данных
  String tmzID = ' ';
//   List<TMZGroup> groupsTMZ = [];
  Future<void> updateTMZInGroups() async {
//   try {
//     final response = await http.get(
//       Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/'), // Замените на ваш URL для групп ТМЗ
//       headers: {'Authorization': 'Bearer ${widget.token}'},
//     );
//     if (response.statusCode == 200) {

//       print('Данные групп успешно получены');
//       print(response.statusCode);
//       List<dynamic> groupsJson = jsonDecode(response.body);
//       setState(() {
//         // Обновление состояния групп ТМЗ
//        TMZGroup groupsTMZ = groupsJson.map((json) => TMZGroup.fromJson(json)).toList();
//       });
//     } else {
//       print('Ошибка при получении данных групп: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Ошибка при запросе данных групп: $e');
//   }
  }

Future<void> deleteTMZbyID(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/delete/$binClient/${widget.groupName}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      // Успешно удалено, обновляем состояние списка синхронно
      setState(() {
        widget.material.removeWhere((element) => element.tmzId == id);
      });
      print('Успешно удалено ТМЗ с id: $id из группы ${widget.groupName}');
    } else {
      print('Ошибка при удалении ТМЗ: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка при отправке запроса на удаление: $e');
  }
}



  Future<void> _addTMZ() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'bin': binClient ?? "",
          'groupName': widget.keys ?? "",
          'tmzMaterialData': {
            "itemTmzName": itemTmzNameController.text.isNotEmpty
                ? itemTmzNameController.text
                : "",
            "sellerBIN": sellerBINController.text.isNotEmpty
                ? sellerBINController.text
                : "",
            "sellerTMZContact": sellerTMZContactController.text.isNotEmpty
                ? sellerTMZContactController.text
                : "",
            "sellerTMZCountry": sellerTMZCountryController.text.isNotEmpty
                ? sellerTMZCountryController.text
                : "",
            "codeitem": codeItemController.text.isNotEmpty
                ? codeItemController.text
                : "",
            "tmzSezon": tmzSezonController.text.isNotEmpty
                ? tmzSezonController.text
                : "",
            "tmzModel": tmzModelController.text.isNotEmpty
                ? tmzModelController.text
                : "",
            "tmzComment": tmzCommentController.text.isNotEmpty
                ? tmzCommentController.text
                : "",
            "tmzPerson": tmzPersonController.text.isNotEmpty
                ? tmzPersonController.text
                : "",
            "tmzSize":
                tmzSizeController.text.isNotEmpty ? tmzSizeController.text : "",
            "tmzColor": tmzColorController.text.isNotEmpty
                ? tmzColorController.text
                : "",
            "tmzExpiryDate": '2026-12-31T00:00:00.000Z',
            "tmzQuantity": tmzQuantityController.text.isEmpty
                ? 0
                : int.parse(tmzQuantityController.text),
            "tmzUnit":
                tmzUnitController.text.isNotEmpty ? tmzUnitController.text : "",
            "tmzPurchaseprice": tmzPurchasepriceController.text.isEmpty
                ? 0
                : int.parse(tmzPurchasepriceController.text),
            "tmzSellingprice": tmzSellingpriceController.text.isEmpty
                ? 0
                : int.parse(tmzSellingpriceController.text),
          },
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        MaterialTmz tmzModal = MaterialTmz.fromJson(responseBody);

        setState(() {
          widget.material.add(tmzModal);
        });

        // Вызов функции getTMZ после успешного добавления
        await updateTMZInGroups();
      } else {
        print('Ошибка при добавлении ТМЗ: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка при отправке запроса: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    updateTMZInGroups(); // Вызываем getTMZ() при инициализации страницы
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keys ?? ''),
      ),
      body: RefreshIndicator(
        onRefresh: updateTMZInGroups, // Вызываем getTMZ при тяжении вниз
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Отображаем индикатор загрузки, пока идет запрос
            : ListView.builder(
                itemCount: widget.material.length,
                itemBuilder: (context, index) {
                  MaterialTmz materialTmz = widget.material[index];
                  return Dismissible(
                    key: Key(materialTmz.tmzId),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      // Удаляем элемент из списка и вызываем setState для обновления состояния
                      setState(() {
                        widget.material.removeAt(index);
                      });
                      deleteTMZbyID(
                          materialTmz.tmzId); // Удаление элемента по его tmzId
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: GestureDetector(
                      child: ListTile(
                        title: Text(materialTmz.itemTmzName),
                        subtitle: Text('Quantity: ${materialTmz.tmzQuantity}'),
                        // Другие детали материала, которые хотите отобразить
                      ),
                    ),
                  );
                },
              ),
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
                          1, // 90% of screen width
                      height: MediaQuery.of(context).size.height *
                          1, // 60% of screen height
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text('Добавить заказ', style: textH1),
                            ),
                            Text(manufacturerIndustryName!),
                            buildTextFormField(
                                'Название ТМЗ', itemTmzNameController),
                            buildTextFormField(
                                'БИН продавца', sellerBINController),
                            buildTextFormField(
                                'Контакт продавца', sellerTMZContactController),
                            buildTextFormField(
                                'Страна продавца', sellerTMZCountryController),
                            buildTextFormField(
                                'Код товара', codeItemController),
                            buildTextFormField('Сезон ТМЗ', tmzSezonController),
                            buildTextFormField(
                                'Модель ТМЗ', tmzModelController),
                            buildTextFormField(
                                'Комментарий к ТМЗ', tmzCommentController),
                            buildTextFormField('К какому полу предназначено',
                                tmzPersonController),
                            buildTextFormField('Размер ТМЗ', tmzSizeController),
                            buildTextFormField('Цвет ТМЗ', tmzColorController),
                            buildTextFormField(
                                'Количество ТМЗ', tmzQuantityController),
                            buildTextFormField(
                                'Единица измерения ТМЗ', tmzUnitController),
                            buildTextFormField(
                                'Цена на покупку', tmzPurchasepriceController),
                            buildTextFormField(
                                'Цена на продажу', tmzSellingpriceController),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _addTMZ();
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
      ),
    );
  }
}
