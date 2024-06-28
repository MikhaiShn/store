import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals/tmzModal.dart';
import 'package:http/http.dart' as http;

class TmzDetailPage extends StatefulWidget {
  final String? keys;
  final String? token;
  List<MaterialTmz> material;
  final Future<void> getTMZ;
  TmzDetailPage(
      {super.key,
      required this.keys,
      required this.token,
      required this.material,
      required this.getTMZ});

  @override
  State<TmzDetailPage> createState() => _TmzDetailPageState();
}

class _TmzDetailPageState extends State<TmzDetailPage> {
  String tmzGroupName = tmzGroupNameController.text;
Future<void> _addTMZ() async {
  print('Вызван метод _addTMZ'); 
  print('groupName ${widget.keys}');

  try {
    // Создание POST запроса
    final response = await http.post(
      Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/tmz/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'bin': binClient ?? "",
        'groupName': widget.keys ?? "",
        'tmzMaterialData': {
          "itemTmzName": itemTmzNameController.text.isNotEmpty ? itemTmzNameController.text : "",
          "sellerBIN": sellerBINController.text.isNotEmpty ? sellerBINController.text : "",
          "sellerTMZContact": sellerTMZContactController.text.isNotEmpty ? sellerTMZContactController.text : "",
          "sellerTMZCountry": sellerTMZCountryController.text.isNotEmpty ? sellerTMZCountryController.text : "",
          "codeitem": codeItemController.text.isNotEmpty ? codeItemController.text : "",
          "tmzSezon": tmzSezonController.text.isNotEmpty ? tmzSezonController.text : "",
          "tmzModel": tmzModelController.text.isNotEmpty ? tmzModelController.text : "",
          "tmzComment": tmzCommentController.text.isNotEmpty ? tmzCommentController.text : "",
          "tmzPerson": tmzPersonController.text.isNotEmpty ? tmzPersonController.text : "",
          "tmzSize": tmzSizeController.text.isNotEmpty ? tmzSizeController.text : "",
          "tmzColor": tmzColorController.text.isNotEmpty ? tmzColorController.text : "",
          "tmzExpiryDate": '2026-12-31T00:00:00.000Z',  // Предположим, что это фиксированная дата
          "tmzQuantity": tmzQuantityController.text.isEmpty ? 0 : int.parse(tmzQuantityController.text),
          "tmzUnit": tmzUnitController.text.isNotEmpty ? tmzUnitController.text : "",
          "tmzPurchaseprice": tmzPurchasepriceController.text.isEmpty ? 0 : int.parse(tmzPurchasepriceController.text),
          "tmzSellingprice": tmzSellingpriceController.text.isEmpty ? 0 : int.parse(tmzSellingpriceController.text),
        },
      }),
    );

    print(response.statusCode);

    // Обработка ответа
    if (response.statusCode == 201) {
      print('ТМЗ успешно добавлен');
      final responseBody = jsonDecode(response.body);
      MaterialTmz tmzModal = MaterialTmz.fromJson(responseBody);

      setState(() {
        widget.material.add(tmzModal);
      });

      // Дополнительные действия после успешного обновления состояния
      await widget.getTMZ;
    } else {
      print('Ошибка при добавлении ТМЗ: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка при отправке запроса: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.keys!),
        ),
        body: ListView.builder(
          itemCount: widget.material.length,
          itemBuilder: (context, index) {
            MaterialTmz materialTmz = widget.material[index];
            return ListTile(
              title: Text(materialTmz.itemTmzName),
              subtitle: Text('Quantity: ${materialTmz.tmzQuantity}'),
              // Другие детали материала, которые хотите отобразить
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
                              buildTextFormField('Контакт продавца',
                                  sellerTMZContactController),
                              buildTextFormField('Страна продавца',
                                  sellerTMZCountryController),
                              buildTextFormField(
                                  'Код товара', codeItemController),
                              buildTextFormField(
                                  'Сезон ТМЗ', tmzSezonController),
                              buildTextFormField(
                                  'Модель ТМЗ', tmzModelController),
                              buildTextFormField(
                                  'Комментарий к ТМЗ', tmzCommentController),
                              buildTextFormField('К какому полу предназначено',
                                  tmzPersonController),
                              buildTextFormField(
                                  'Размер ТМЗ', tmzSizeController),
                              buildTextFormField(
                                  'Цвет ТМЗ', tmzColorController),
                              buildTextFormField(
                                  'Количество ТМЗ', tmzQuantityController),
                              buildTextFormField(
                                  'Единица измерения ТМЗ', tmzUnitController),
                              buildTextFormField('Цена на покупку',
                                  tmzPurchasepriceController),
                              buildTextFormField(
                                  'Цена на продажу', tmzSellingpriceController),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _addTMZ();
                                    Navigator.of(context).pop();
                                    await widget.getTMZ;
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
                          onPressed: () async {
                            Navigator.of(context)
                                .pop(); 
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
        ));
  }
}
