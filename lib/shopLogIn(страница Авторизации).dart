import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop.dart';
export 'package:shop_apllication_1/modals/AuthModal.dart';
import 'package:http/http.dart' as http;

import 'Заказы/shopAllOrders.dart';
import 'Заказы/shopAllOrdersManager.dart';

class ShopLogIn extends StatefulWidget {
  const ShopLogIn({Key? key}) : super(key: key);

  @override
  State<ShopLogIn> createState() => _ShopLogInState();
}

class _ShopLogInState extends State<ShopLogIn> {
  bool show = true;
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse(
          'https://sheltered-peak-32126-a4bd3f8cb65e.herokuapp.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'login': _loginController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Response body: $responseBody'); // Логирование тела ответа
      token = responseBody['token'];

      if (token != null) {
        try {
          Map<String, dynamic> payload = Jwt.parseJwt(token!);
          role = payload['role'];
          binClient = payload['bin'];
          manufacturerIndustryName = payload['manufacturerIndustry'];
          String? id = payload['_id'] as String?;
          // Вывод данных для отладки
        } catch (e) {
          print("Error while parsing JWT payload: $e");
          _showErrorDialog(context, "Ошибка при обработке токена");
        }
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ошибка"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets1/background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.65,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets1/logo.png'),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _loginController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.login, color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Login',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: show,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.password, color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                show = !show;
                              });
                            },
                            child: Icon(
                              show ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Transform.translate(
                      offset: Offset(0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _login().then((_) {
                              if (token != null) {
                                print('role: $role');
                                print('bin: $binClient');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Shop(token: token!)),
                                );
                              } else {
                                // Если токен равен null, обработка ошибки или отображение сообщения пользователю
                                _showErrorDialog(
                                    context, "Неправильный логин или пароль");
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 35), // Регулируем размеры кнопки
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Закругленные углы
                            ),
                          ),
                          child: Text(
                            'Войти',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18), // Размер и цвет текста
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
