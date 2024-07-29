import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/calculation/shop_calculation.dart';
import 'package:shop_apllication_1/shop_raw_materials/shopMaterials(%D0%A1%D1%8B%D1%80%D1%8C%D1%91).dart';
import 'package:shop_apllication_1/modals_file/calculation_modals.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/shop_tmz/shop_tmz.dart';

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

  Future<void> deleteComponentInGroup(String componentId) async {
    final response = await http.delete(
      Uri.parse(
          'https://baskasha-353162ef52af.herokuapp.com/calculation/${widget.calculationID}/models/${widget.modelsID}/sizes/${widget.sizeID}/components/$componentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      print('Компонент успешно удален');
      // После успешного удаления обновите список компонентов
      getComponentsInGroup();
    } else {
      print('Ошибка при удалении компонента: ${response.statusCode}');
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
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
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
                                        builder: (context) => ShopTMZ(
                                              token: widget.token,
                                              checkCalculate: 'Калькуляция',
                                              calculationID:
                                                  widget.calculationID,
                                              modelsID: widget.modelsID,
                                              sizeId: widget.sizeID,
                                            )));
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
          final component = components[index];
          return GestureDetector(
            onTap: () {
              _showComponentDetails(component);
            },
            child: Dismissible(
              key: ValueKey(component.id),
              confirmDismiss: (direction) async {
                bool? shouldDelete = await showModalBottomSheet<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Удалить компонент?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Вы уверены, что хотите удалить этот компонент?',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Удалить'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Отмена'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );

                if (shouldDelete == true) {
                  await deleteComponentInGroup(component.id);
                }
                return shouldDelete;
              },
              background: Container(
                color: const Color.fromRGBO(244, 67, 54, 1),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тип компонента: ${component.componentType}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Название: ${component.componentName}'),
                        SizedBox(height: 5),
                        Text('Количество: ${component.quantity}'),
                      ],
                    ),
                  ),
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
