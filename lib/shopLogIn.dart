import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shop.dart';
import 'package:shop_apllication_1/shopRegistr.dart';

class ShopLogIn extends StatefulWidget {
  ShopLogIn({Key? key}) : super(key: key);

  @override
  State<ShopLogIn> createState() => _ShopLogInState();
}

class _ShopLogInState extends State<ShopLogIn> {
  bool show = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 141, 102, 88),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Вход',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Shop()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 141, 102, 88),
                ),
                child: Text(
                  'Войти',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShopRegister()));
              },child: Text('Если у вас нет аккаунта зарегистрируйтесь здесь',style: TextStyle(color: Colors.blue),),)
            ],
          ),
        ),
      ),
    );
  }
}
