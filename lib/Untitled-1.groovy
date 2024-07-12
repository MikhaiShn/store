

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_apllication_1/modals/calculateModals.dart';
import 'package:shop_apllication_1/Калькуляция/shopCalculationDetail.dart';

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
      print('Response Body: $responseBody');
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
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/$calculationID/models';

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
        'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/$calculationID/models/$modalId/sizes',
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
    print('$modalId');
    if (response.statusCode == 201) {
      print('Размер успешно добавлен');
      getCompleteModel();
    } else {
      print('Ошибка при добавлении размера: ${response.statusCode}');
    }
  }

  Future<void> putModel(String calculationID, String modelID) async {
    final response = await http.put(Uri.parse('https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/$calculationID/models/$modelID'),
          headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    body: jsonEncode({
{
    "modelName": modalCalculateController.text,
    "sizeVariations": []
}
    });
    if (response.statusCode == 200){
      print('Название модели успешно изменено');
    } else {
      print('Ошибка при загрузке калькуляции: ${response.statusCode}');
    }
  }

  Future<void> deleteModel(String calculationID, String modalId) async {
    final response = await http.delete(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/$calculationID/models/$modalId'),
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

  Future<void> deleteSize(String calculationID, String modalId, String sizeID) async {
    print('Запуск удаления размера в модели');
    final response = await http.delete(
        Uri.parse(
            'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/calculation/$calculationID/models/$modalId/sizes/$sizeID'),
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

  void showAddModelDialog(String calculationID) {
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
                postNewModel(calculationID);
              },
            ),
          ],
        );
      },
    );
  }
 bool containerPressed = false;
  void showSizeDialog(String calculationID, String modalId) {
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
                postNewSize(calculationID, modalId);
                Navigator.of(context).pop();
              },
            ),
            if(containerPressed)
              IconButton(onPressed: () {}, icon: Icon(Icons.abc))
            
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
              if (calculate.isNotEmpty) {
                showAddModelDialog(calculate.first.id);
              }
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: takeListCalculate.itemModels.length,
                            itemBuilder: (context, idx) {
                              final itemModel =
                                  takeListCalculate.itemModels[idx];
                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
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
                                                          takeListCalculate
                                                              .id,
                                                          itemModel.id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        Text('Удалить'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                  color: Colors.grey[200],
                                  child: Column(
                                    children: [
                                      ExpansionTile(
                                        title: ListTile(
                                          title: Text(
                                              'Модель: ${itemModel.modelName}'),
                                          trailing: IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              showSizeDialog(
                                                  takeListCalculate.id,
                                                  itemModel.id);
                                            },
                                          ),
                                        ),
                                      
                                     children: [ ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            NeverScrollableScrollPhysics(),
                                        itemCount:
                                            itemModel.sizeVariations.length,
                                        itemBuilder: (context, idx) {
                                          final itemSize = itemModel
                                              .sizeVariations[idx];
                                          return GestureDetector(
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    context) {
                                                  return Dialog(
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.2,
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height *
                                                          0.2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'Вы уверены что хотите удалить?'),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  deleteSize(
                                                                      takeListCalculate
                                                                          .id,
                                                                      itemModel
                                                                          .id,
                                                                      itemSize
                                                                          .id);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Удалить'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Отмена'),
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
                                                title: Text(
                                                    'Размер: ${itemSize.size}'),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShopCalculationDetail(
                                                              sizeID: itemSize
                                                                  .id,
                                                              modelsID:
                                                                  itemModel
                                                                      .id,
                                                              calculationID:
                                                                  takeListCalculate
                                                                      .id,
                                                              token: widget
                                                                  .token),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),]
                                  ),
                                  ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
