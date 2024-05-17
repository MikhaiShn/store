import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop.dart';
import 'package:shop_apllication_1/shopRegisterAdmin.dart';
import 'package:shop_apllication_1/shopRegisterManager.dart';
import 'package:shop_apllication_1/shopRegistr.dart';

class ShopLogIn extends StatefulWidget {
  const ShopLogIn({Key? key}) : super(key: key);

  @override
  State<ShopLogIn> createState() => _ShopLogInState();
}

class _ShopLogInState extends State<ShopLogIn> {
  bool show = true;
  String selectedRole = 'Administrator';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brown,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Вход',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRole = 'Administrator';
                      });
                    },
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: selectedRole == 'Administrator'
                              ? Colors.black
                              : Colors.transparent,
                          width: 2.0,
                        ))),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text('Administrator'),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRole = 'Manager';
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: selectedRole == 'Manager'
                              ? Colors.black
                              : Colors.transparent,
                          width: 2.0,))),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text('Manager'),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.login),
                    labelText: 'Login',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  obscureText: show,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.password),
                    labelText: 'Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      child: Icon(
                        show ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Shop()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 141, 102, 88),
                ),
                child: Text(
                  'Войти',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (selectedRole == 'Administrator') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationAdmin()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationManager()));
                  }
                },
                child: Text(
                  'Если у вас нет аккаунта зарегистрируйтесь здесь',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
