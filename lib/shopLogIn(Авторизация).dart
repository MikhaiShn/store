import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop.dart';

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
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      prefixIcon: Icon(Icons.login, color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Login',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: show,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Цвет бордюра при фокусе
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Shop()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                  ),
                  child: Text(
                    'Войти',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ShopRegister()));
                //     // if (selectedRole == 'Administrator') {
                //     //   Navigator.push(
                //     //       context,
                //     //       // MaterialPageRoute(
                //     //       //     builder: (context) => RegistrationAdmin()));
                //     // } else {
                //     //   Navigator.push(
                //     //       context,
                //     //       MaterialPageRoute(
                //     //           builder: (context) => RegistrationManager()));
                //     // }
                //   },
                //   // child: Text(
                //   //   'Если у вас нет аккаунта зарегистрируйтесь здесь',
                //   //   style: TextStyle(color: Colors.blue),
                //   // ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
