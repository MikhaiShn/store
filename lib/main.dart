
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_apllication_1/shopLogIn(%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D0%B0%20%D0%90%D0%B2%D1%82%D0%BE%D1%80%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8).dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: const FirebaseOptions(    
    apiKey: 'AIzaSyAEUWFPjpj-osIjOIEFljtN3iTwsN1Fl6s',
    appId: '1:502017115919:android:4f97bb6c06be84aec8a07a',
    messagingSenderId: '502017115919',
    projectId: 'dbimage-2a767',
    storageBucket: 'dbimage-2a767.appspot.com',)); 
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
      title: 'Flutter Firebase Storage Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      home: ShopLogIn(),
    );
  }
}

