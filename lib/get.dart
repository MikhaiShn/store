import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_apllication_1/RegisterModals/shopLoginModal.dart';

class Get extends StatefulWidget {
  const Get({super.key});

  @override
  State<Get> createState() => _GetState();
}

class _GetState extends State<Get> {
  List<StoreRegister> store1 = [];
  Future getFromServer() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/register/all'));
        List<dynamic> store2 = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        store1 = store2.map((misha) => StoreRegister.fromJson(misha)).toList();
      });
    } else {
      throw 'Ошибка';
    }
  }

  @override
  void initState() {
    super.initState();
    getFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('data'),
        ),
        body: ListView.builder(itemCount: store1.length,itemBuilder: (context, index) {
          return Column(
            children: [
               Text('Manufacturer Name: ${store1[index].manufacturerName ?? "N/A"}'),
            ],
          );
        }));
  }
}
