import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/calculateModals.dart';

class ShopCalculation extends StatefulWidget {
  final String token;

  ShopCalculation({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopCalculation> createState() => _ShopCalculationState();
}

class _ShopCalculationState extends State<ShopCalculation> {
  List<CalculateModal> calculate = [];
  List<String> idModal = [];
  bool isLoading = false;
  int? expandedIndex;

  TextEditingController modalCalculateController = TextEditingController();
  TextEditingController sizeCalculateController = TextEditingController();

  Future<void> getCompleteModel() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);
      calculate =
          responseBody.map((data) => CalculateModal.fromJson(data)).toList();

      // Очистка и заполнение массива idModal

      print('Калькуляция успешно получена');
    } else {
      print('Ошибка при загрузке калькуляции: ${response.statusCode}');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> postNewModel() async {
    final String url =
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/6682761f258144d6d62abf26/models';

    final Map<String, dynamic> requestData = {
      "modelName": modalCalculateController.text,
      "sizeVariations": []
    };

    final String jsonBody = jsonEncode(requestData);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      print('Успешно добавлена новая модель');
      modalCalculateController
          .clear(); // Очистка поля после успешного добавления
      Navigator.of(context)
          .pop(); // Закрытие диалогового окна после успешного добавления
      getCompleteModel(); // Обновление списка после добавления модели
    } else {
      print('Ошибка при добавлении модели: ${response.statusCode}');
      print('Тело запроса: $jsonBody'); // Логирование тела запроса для отладки
    }
  }

  Future<void> postNewSize(String modalId) async {
    final response = await http.post(
      Uri.parse(
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/6682761f258144d6d62abf26/models/$modalId/sizes',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        "size": sizeCalculateController.text,
        "components": [],
        "laborCosts": []
      }),
    );

    if (response.statusCode == 201) {
      print('Размер успешно добавлен');
      getCompleteModel();
    } else {
      print('Ошибка при добавлении размера: ${response.statusCode}');
    }
  }

  Future<void> deleteModel(String modelID) async {
    final response = await http.delete(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/6682761f258144d6d62abf26/models/$modelID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        });
    if (response.statusCode == 200) {
      print("Модель успешно удалена");
      getCompleteModel();
    }
  }

  Future<void> deleteSize(String modelID, String sizeID) async {
    print('Запуск удаления размера в модели');
    final response = await http.delete(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/6682761f258144d6d62abf26/models/$modelID/sizes/$sizeID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        });
        print('modelID: $modelID');
        print('sizeID: $sizeID'); 
        print(response.statusCode);
        if(response.statusCode == 200){
          print('Успешно удалено');
          getCompleteModel();
        }
  }

  @override
  void initState() {
    super.initState();
    getCompleteModel();
  }

  void showAddModelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить новую модель'),
          content: TextField(
            controller: modalCalculateController,
            decoration: InputDecoration(labelText: 'Название модели'),
          ),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                postNewModel(); // Замените 'calculationId' на реальный идентификатор калькуляции
              },
            ),
          ],
        );
      },
    );
  }

  void showSizeDialog(String modalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить размер модели'),
          content: TextField(
            controller: sizeCalculateController,
            decoration: InputDecoration(labelText: 'Размер модели'),
          ),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                postNewSize(modalId); // Передаем modalId для добавления размера
                Navigator.of(context).pop(); // Закрываем диалоговое окно
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Калькуляция'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddModelDialog();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : calculate.isEmpty
              ? Center(child: Text('Данные о калькуляции отсутствуют'))
              : ListView.builder(
                  itemCount: calculate.length,
                  itemBuilder: (context, index) {
                    final takeListCalculate = calculate[index];

                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            title: ListTile(
                              title: Text('BIN: ${takeListCalculate.bin}'),
                              subtitle: Text(
                                  'Производственная отрасль: ${takeListCalculate.manufacturerIndustry}'),
                            ),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                    'Комментарий: ${takeListCalculate.comment}'),
                              ),
                              SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: takeListCalculate.itemModels.length,
                                itemBuilder: ((context, idx) {
                                  final itemModel =
                                      takeListCalculate.itemModels[idx];
                                  final modalId = itemModel.id;
                                  return GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.2,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'Вы уверены что хотите удалить?'),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              deleteModel(
                                                                  modalId);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text('Да')),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text('Нет')),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: ExpansionTile(
                                      title: Text(itemModel.modelName),
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              itemModel.sizeVariations.length,
                                          itemBuilder: (context, sizeIdx) {
                                            final sizeVariation = itemModel
                                                .sizeVariations[sizeIdx];
                                            return GestureDetector(
                                            onLongPress: () {
                                                                                    showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.2,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'Вы уверены что хотите удалить?'),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              deleteSize(
                                                                  modalId,sizeVariation.id);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text('Да')),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text('Нет')),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                            },
                                              child: ListTile(
                                                title: Text(
                                                    'Размер: ${sizeVariation.size}'),
                                                subtitle: Text(
                                                    'Компоненты: ${sizeVariation.components.length}'),
                                              ),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          title: Text('Добавить Размер'),
                                          onTap: () {
                                            showSizeDialog(modalId);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
    );
  }
}
