import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/modals_file/calculation_modals.dart';
import 'package:shop_apllication_1/calculation/shop_calculation_detail.dart';

class ShopCalculation extends StatefulWidget {
  final String token;

  ShopCalculation({Key? key, required this.token}) : super(key: key);

  @override
  State<ShopCalculation> createState() => _ShopCalculationState();
}

class _ShopCalculationState extends State<ShopCalculation> {
  List<CalculateModal> calculate = [];
  bool isLoading = false;
  TextEditingController modalCalculateController = TextEditingController();
  TextEditingController sizeCalculateController = TextEditingController();
  TextEditingController putModalCalculateController = TextEditingController();
  TextEditingController putSizeCalculateController = TextEditingController();
  bool containerPressed = false;

  Future<void> getCompleteModel() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://baskasha-353162ef52af.herokuapp.com/calculation/bin/$binClient'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);
      try {
        calculate =
            responseBody.map((data) => CalculateModal.fromJson(data)).toList();
        print('Калькуляция успешно получена');
      } catch (e) {
        print('Ошибка при преобразовании данных: $e');
      }
    } else {
      print('Ошибка при загрузке калькуляции: ${response.statusCode}');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> postNewModel(String calculationID) async {
    final String url =
        'https://baskasha-353162ef52af.herokuapp.com/calculation/$calculationID/models';

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
      modalCalculateController.clear();
      Navigator.of(context).pop();
      getCompleteModel();
    } else {
      print('Ошибка при добавлении модели: ${response.statusCode}');
      print('Тело запроса: $jsonBody');
    }
  }

  Future<void> postNewSize(String calculationID, String modalId) async {
    final response = await http.post(
      Uri.parse(
        'https://baskasha-353162ef52af.herokuapp.com/calculation/$calculationID/models/$modalId/sizes',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        "costSize": sizeCalculateController.text,
        "costUnit": "Пара",
        "sizeComment": "Комментарий",
        "codeitem": "001"
      }),
    );
    print('$modalId');
    if (response.statusCode == 201) {
      print('Размер успешно добавлен');
      getCompleteModel();
    } else {
      print('Ошибка при добавлении размера: ${response.statusCode}');
    }
  }

  Future<void> putModel(String calculationID, String modelID) async {
    final response = await http.put(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/calculation/$calculationID/models/$modelID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "modelName": putModalCalculateController.text,
          "sizeVariations": []
        }));

    if (response.statusCode == 200) {
      print('Название модели успешно изменено');
      getCompleteModel();
    } else {
      print('Ошибка при загрузке калькуляции: ${response.statusCode}');
    }
  }

  Future<void> putsize(
      String calculationID, String modelID, String sizeID) async {
    final response = await http.put(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/calculation/$calculationID/models/$modelID/sizes/$sizeID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({"size": putSizeCalculateController.text}));

    if (response.statusCode == 200) {
      print('Размер успешно изменен');
      getCompleteModel();
    } else {
      print('Ошибка при изменении размера: ${response.statusCode}');
    }
  }

  Future<void> deleteModel(String calculationID, String modalId) async {
    final response = await http.delete(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/calculation/$calculationID/models/$modalId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        });
    if (response.statusCode == 200) {
      print("Модель успешно удалена");
      getCompleteModel();
    } else {
      print('Ошибка при удалении модели: ${response.statusCode}');
    }
  }

  Future<void> deleteSize(
      String calculationID, String modalId, String sizeID) async {
    print('Запуск удаления размера в модели');
    final response = await http.delete(
        Uri.parse(
            'https://baskasha-353162ef52af.herokuapp.com/calculation/$calculationID/models/$modalId/sizes/$sizeID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        });
    print('calculationID: $calculationID');
    print('modelID: $modalId');
    print('sizeID: $sizeID');
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Успешно удалено');
      getCompleteModel();
    } else {
      print('Ошибка при удалении размера: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getCompleteModel();
  }

  void showDialogPutAndDelete(
    String calculationID,
    String titleText,
    String labelText,
    String leftButton,
    String rightButton,
    TextEditingController controller,
    Future<void> Function()
        function, // Изменили тип аргумента на функцию без параметров
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: labelText),
          ),
          actions: [
            TextButton(
              child: Text(leftButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(rightButton),
              onPressed: () async {
                // Используем async для вызова асинхронной функции
                Navigator.of(context).pop();
                await function(); // Вызываем переданную функцию
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
              showDialog(
                  context: context,
                  builder: (BuildContext content) {
                    return Dialog(
                      child: Column(
                        children: [
                          buildTextFormField('Новое название модели',
                              modalCalculateController),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Отмена')),
                          ElevatedButton(
                              onPressed: () {
                                postNewModel(calculate.first.id);
                              },
                              child: Text('Добавить'))
                        ],
                      ),
                    );
                  });
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
              return Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: takeListCalculate.itemModels.length,
                          itemBuilder: (context, idx) {
                            final itemModel = takeListCalculate.itemModels[idx];
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Вы уверены что хотите удалить?'),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    deleteModel(takeListCalculate.id, itemModel.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Удалить'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Отмена'),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                        title: ListTile(
                                          title: Text('Модель: ${itemModel.modelName}'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  showDialogPutAndDelete(
                                                      takeListCalculate.id,
                                                      'Добавить новую вариацию размера',
                                                      'Размер',
                                                      'Назаж',
                                                      'Сохранить',
                                                      sizeCalculateController,
                                                      () => postNewSize(takeListCalculate.id, itemModel.id));
                                                },
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialogPutAndDelete(
                                                        takeListCalculate.id,
                                                        'Изменить название модели',
                                                        'Новое название модели',
                                                        'Отмена',
                                                        'Сохранить',
                                                        putModalCalculateController,
                                                        () => putModel(takeListCalculate.id, itemModel.id));
                                                  },
                                                  icon: Icon(Icons.edit))
                                            ],
                                          ),
                                        ),
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: itemModel.sizeVariations.length,
                                            itemBuilder: (context, idx) {
                                              final itemSize = itemModel.sizeVariations[idx];
                                              return GestureDetector(
                                                onLongPress: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Dialog(
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.2,
                                                          height: MediaQuery.of(context).size.height * 0.2,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text('Вы уверены что хотите удалить?'),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed: () {
                                                                      deleteSize(takeListCalculate.id, itemModel.id, itemSize.id);
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text('Удалить'),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text('Отмена'),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Card(
                                                  color: Colors.white,
                                                  child: ListTile(
                                                    title: Text('Размер: ${itemSize.costSize}'),
                                                    trailing: IconButton(
                                                      onPressed: () {
                                                        showDialogPutAndDelete(
                                                          takeListCalculate.id,
                                                          'Изменить название размера',
                                                          'Новое название',
                                                          'Отмена',
                                                          'Сохранить',
                                                          putSizeCalculateController,
                                                          () => putsize(takeListCalculate.id, itemModel.id, itemSize.id),
                                                        );
                                                      },
                                                      icon: Icon(Icons.edit),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ShopCalculationDetail(
                                                              sizeID: itemSize.id,
                                                              modelsID: itemModel.id,
                                                              calculationID: takeListCalculate.id,
                                                              token: widget.token),
                                                        ),
                                                      );
                                                    },
                                                    
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ]),
                                        SizedBox(height: 20,)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40), // Отступ между контейнерами
                ],
              );
            },
          ),
    );
  }
}
