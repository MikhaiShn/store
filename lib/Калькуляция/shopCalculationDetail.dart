import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/%D0%A1%D1%8B%D1%80%D1%8C%D1%91/shopMaterials(%D0%A1%D1%8B%D1%80%D1%8C%D1%91).dart';
import 'package:shop_apllication_1/modals/calculateModals.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/shopTMZ(%D0%A2%D0%9C%D0%97).dart';

class ShopCalculationDetail extends StatefulWidget {
  final String token;
  final String calculationID;
  final String modelsID;
  final String sizeID;

  ShopCalculationDetail({
    Key? key,
    required this.token,
    required this.calculationID,
    required this.modelsID,
    required this.sizeID,
  }) : super(key: key);

  @override
  _ShopCalculationDetailState createState() => _ShopCalculationDetailState();
}

class _ShopCalculationDetailState extends State<ShopCalculationDetail> {
  List<Component> components = [];

  Future<void> getComponentsInGroup() async {
    final response = await http.get(
      Uri.parse(
          'https://baskasha-353162ef52af.herokuapp.com/calculation/${widget.calculationID}/models/${widget.modelsID}/sizes/${widget.sizeID}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      print('Компоненты получены успешно');
      try {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Предполагая, что компоненты находятся под ключом 'components'
        if (responseData.containsKey('components')) {
          List<dynamic> componentsData = responseData['components'];
          setState(() {
            components =
                componentsData.map((data) => Component.fromJson(data)).toList();
          });
        }
        print(components);
      } catch (e) {
        print('Ошибка при преобразовании данных: $e');
      }
    } else {
      print('Ошибка при загрузке компонентов: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getComponentsInGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Компоненты калькуляции'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: 'Выберите компонент'),
                            items: [
                              DropdownMenuItem(
                                value: 'сырье',
                                child: Text('Сырье'),
                              ),
                              DropdownMenuItem(
                                value: 'тмз',
                                child: Text('ТМЗ'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == 'сырье') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopMaterials(
                                              token: widget.token,
                                              checkCalculate: 'Калькуляция',
                                              calculationID:
                                                  widget.calculationID,
                                              modelsID: widget.modelsID,
                                              sizeID: widget.sizeID,
                                            )));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopTMZ(token: widget.token)));
                              }
                              print(value);
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Закрыть'),
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
        itemCount: components.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showComponentDetails(components[index]);
            },
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип компонента: ${components[index].componentType}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Название: ${components[index].componentName}'),
                    SizedBox(height: 5),
                    Text('Количество: ${components[index].quantity}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showComponentDetails(Component component) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Детали компонента'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Тип компонента: ${component.componentType}'),
                Text('ID компонента: ${component.componentId}'),
                Text('Название: ${component.componentName}'),
                Text('Импортный: ${component.componentImport ? "Да" : "Нет"}'),
                Text('Модель: ${component.model}'),
                Text('Комментарий: ${component.comment}'),
                Text('Размер: ${component.size}'),
                Text('Цвет: ${component.color}'),
                Text('Единица измерения: ${component.unit}'),
                Text('Количество: ${component.quantity}'),
                Text('Цена покупки: ${component.purchaseprice}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
