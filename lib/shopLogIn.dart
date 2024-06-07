import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shop_apllication_1/%D0%A1%D1%8B%D1%80%D1%8C%D1%91/shopMaterials(%D0%A1%D1%8B%D1%80%D1%8C%D1%91).dart';
import 'package:shop_apllication_1/AuthModal.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop.dart';
export 'package:shop_apllication_1/AuthModal.dart';
import 'package:http/http.dart' as http;


class ShopLogIn extends StatefulWidget {

  const ShopLogIn({Key? key}) : super(key: key);

  @override
  State<ShopLogIn> createState() => _ShopLogInState();
}


class _ShopLogInState extends State<ShopLogIn> {
  bool show = true;
  String selectedRole = 'Administrator';
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _token;
  
  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/auth/login'),
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
      _token = responseBody['token'];
      AuthLogin authLogin = AuthLogin.fromJson(responseBody);
      authLogin.login = _loginController.text;
      authLogin.password = _passwordController.text;

      if (_token != null) {
        Map<String, dynamic> payload = Jwt.parseJwt(_token!);
        String? role = payload['role'];
        binClient = payload['bin'];
        manufacturerIndustryName = payload['manufacturerIndustry']; 
        if (role == 'WarehouseManager') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShopMaterials()),
          );
          print(role);
        } else if (role =='WarehouseAdmin') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Shop(token: _token!)));
        } else {
          _showErrorDialog(context, "Вы вошли в систему, но ваша роль не определена");
        }
      } else {
        _showErrorDialog(context, "Ошибка авторизации");
      }
    } else if (response.statusCode == 401) {
      _showErrorDialog(context, "Пользователь c таким логином не найден");
    } else if (response.statusCode == 402) {
      _showErrorDialog(context, "Неправильный пароль");
    } else {
      _showErrorDialog(context, "Ошибка сервера");
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: greyTransparentColor,
          image: DecorationImage(
            image: AssetImage('assets1/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.login, color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.password, color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
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
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                  ),
                  child: Text(
                    'Войти',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
