import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Заказы/getZakaz.dart';

class GetStt extends StatefulWidget {
  const GetStt({super.key});

  @override
  State<GetStt> createState() => _GetSttState();
}

class _GetSttState extends State<GetStt> {
  List<GetZakaz> _orders = []; // Список для хранения заказов

  Future<void> getZakaz() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/zakazy/zakaz-all'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          _orders = responseBody.map((data) => GetZakaz.fromJson(data)).toList();
        });
      } else {
        print('Ошибка при получении заказов: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getZakaz(); // Вызов метода для получения заказов при инициализации
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Отображение списка заказов
          Expanded(
            child: ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ListTile(
                  title: Text(order.zakazModel!),
                  subtitle: Text('ID: ${order.zakazID}, Количество: ${order.zakazQuantity}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
