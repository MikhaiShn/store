// import 'dart:convert';
// import 'package:shop_apllication_1/RegisterModals/shopRegisterManager.dart';
// import 'package:flutter/material.dart';
// import 'package:shop_apllication_1/globals%20(%D0%A4%D0%B0%D0%B9%D0%BB%20%D0%B4%D0%BB%D1%8F%20%D0%BC%D0%B5%D1%82%D0%BE%D0%B4%D0%BE%D0%B2).dart';
// import 'package:http/http.dart' as http;

// class RegistrationManager extends StatefulWidget {
//   const RegistrationManager({super.key});

//   @override
//   State<RegistrationManager> createState() => _RegistrationManagerState();
// }

// class _RegistrationManagerState extends State<RegistrationManager> {
//   TextEditingController bIN = TextEditingController();
//   TextEditingController companySelerManagerFIO = TextEditingController();
//   TextEditingController companySelerManagerIIN = TextEditingController();
//   TextEditingController companySelerManagerLogin = TextEditingController();
//   TextEditingController companySelerManagerPassword = TextEditingController();
//   String role = 'WarehouseManager';

//   Future<void> postInfoFromServer() async {
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:5000/register/warehouse-manager'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "BIN": bIN.text,
//         "CompanySelerManagerFIO": companySelerManagerFIO.text,
//         "CompanySelerManagerIIN": companySelerManagerIIN.text,
//         "CompanySelerManagerLogin": companySelerManagerLogin.text,
//         "CompanySelerManagerPassword": companySelerManagerPassword.text,
//         "role": role,
//       }),
//     );

//     print('body: ${jsonEncode({
//           "BIN": bIN.text,
//           "CompanySelerManagerFIO": companySelerManagerFIO.text,
//           "CompanySelerManagerIIN": companySelerManagerIIN.text,
//           "CompanySelerManagerLogin": companySelerManagerLogin.text,
//           "CompanySelerManagerPassword": companySelerManagerPassword.text,
//           "role": role,
//         })}');

//     print('hh: ${response.body}');
//     print(response.statusCode);

//     if (response.statusCode == 200) {
//       StoreRegisterManager shopRegisterManager =
//           StoreRegisterManager.fromJson(jsonDecode(response.body));
//       shopRegisterManager.bIN = bIN.text;
//       shopRegisterManager.companySelerManagerFIO = companySelerManagerFIO.text;
//       shopRegisterManager.companySelerManagerIIN = companySelerManagerIIN.text;
//       shopRegisterManager.companySelerManagerLogin =
//           companySelerManagerLogin.text;
//       shopRegisterManager.companySelerManagerPassword =
//           companySelerManagerPassword.text;
//     } else {
//       throw 'Ошибка';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Регистрация Менеджера'),
//       ),
//       body: Column(children: [
//         buildTextFormField('БИН', bIN),
//         buildTextFormField('ФИО', companySelerManagerFIO),
//         buildTextFormField('ИИН', companySelerManagerIIN),
//         buildTextFormField('Логин', companySelerManagerLogin),
//         buildTextFormField('Пороль', companySelerManagerPassword),
//         ElevatedButton(
//             onPressed: () {
//               postInfoFromServer();
//             },
//             child: Text('go'))
//       ]),
//     );
//   }
// }



//   // class WarehouseRegistrationPage extends StatelessWidget {
//   //   Widget build(BuildContext context){
//   //     return Column(

//   //     )
//   //   }
//   // }