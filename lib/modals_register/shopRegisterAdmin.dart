import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apllication_1/modals_register/storeRegisterAdminModal.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:http/http.dart' as http;

class RegistrationAdmin extends StatefulWidget {
  const RegistrationAdmin({super.key});

  @override
  State<RegistrationAdmin> createState() => _RegistrationAdminState();
}

class _RegistrationAdminState extends State<RegistrationAdmin> {
  TextEditingController bIN = TextEditingController();
  TextEditingController companySelerAdminFIO = TextEditingController();
  TextEditingController companySelerAdminIIN = TextEditingController();
  TextEditingController companySelerAdminLogin = TextEditingController();
  TextEditingController companySelerAdminPassword = TextEditingController();
  String role = 'WarehouseAdmin';

  Future<void> postInfoFromServer() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/register/warehouse-admin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "BIN": bIN.text,
        "CompanySelerAdminFIO": companySelerAdminFIO.text,
        "CompanySelerAdminIIN": companySelerAdminIIN.text,
        "CompanySelerAdminLogin": companySelerAdminLogin.text,
        "CompanySelerAdminPassword": companySelerAdminPassword.text,
        "role": role,
      }),
    );

    print('body: ${jsonEncode({
                  "BIN": bIN.text,
        "CompanySelerAdminFIO": companySelerAdminFIO.text,
        "CompanySelerAdminIIN": companySelerAdminIIN.text,
        "CompanySelerAdminLogin": companySelerAdminLogin.text,
        "CompanySelerAdminPassword": companySelerAdminPassword.text,
        "role": role,
        })}');

    print('hh: ${response.body}');
    print(response.statusCode);

    if (response.statusCode == 200) {
      StoreRegisterAdmin shopRegisterAdmin =
          StoreRegisterAdmin.fromJson(jsonDecode(response.body));
      shopRegisterAdmin.bIN = bIN.text;
      shopRegisterAdmin.companySelerAdminFIO = companySelerAdminFIO.text;
      shopRegisterAdmin.companySelerAdminIIN = companySelerAdminIIN.text;
      shopRegisterAdmin.companySelerAdminLogin = companySelerAdminLogin.text;
      shopRegisterAdmin.companySelerAdminPassword = companySelerAdminPassword.text;
    } else {
      throw 'Ошибка';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация Администратора'),
      ),
      body: Column(
        children: [        
        buildTextFormField('БИН', bIN),
        buildTextFormField('ФИО', companySelerAdminFIO),
        buildTextFormField('ИИН', companySelerAdminIIN),
        buildTextFormField('Логин', companySelerAdminLogin),
        buildTextFormField('Пороль', companySelerAdminPassword),
        ElevatedButton(onPressed: () {
          postInfoFromServer();
        }, child: Text('go'))
      ]),
    );
  }
}



  // class WarehouseRegistrationPage extends StatelessWidget {
  //   Widget build(BuildContext context){
  //     return Column(

  //     )
  //   }
  // }