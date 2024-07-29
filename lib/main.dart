import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_apllication_1/globals.dart';
import 'package:shop_apllication_1/shop.dart';
import 'shop_auth.dart';

Future<Map<String, String?>> getData() async {
  final prefs = await SharedPreferences.getInstance();
   token = prefs.getString('authToken');
   role = prefs.getString('role');
   binClient = prefs.getString('binClient');
   manufacturerIndustryName = prefs.getString('manufacturerIndustryName');

  return {
    'token': token,
    'role': role,
    'binClient': binClient,
    'manufacturerIndustryName': manufacturerIndustryName,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAEUWFPjpj-osIjOIEFljtN3iTwsN1Fl6s',
        appId: '1:502017115919:android:4f97bb6c06be84aec8a07a',
        messagingSenderId: '502017115919',
        projectId: 'dbimage-2a767',
        storageBucket: 'dbimage-2a767.appspot.com',
      ),
    );
    print("Successfully connected to Firebase");
  } catch (e) {
    print("Failed to connect to Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        ScreenUtil.init(
          context,
          designSize: Size(360, 640),
          minTextAdapt: true,
          splitScreenMode: true,
        );
        return child!;
      },
      title: 'Flutter Firebase Storage Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Map<String, String?>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Покажите индикатор загрузки пока идет проверка
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data;
             token = data!['token'];

            if (token != null) {
              return Shop(
                token: token!,
              );
            } else {
              return ShopLogIn();
            }
          } else {
            return ShopLogIn(); // В случае ошибки или отсутствия данных
          }
        },
      ),
    );
  }
}
