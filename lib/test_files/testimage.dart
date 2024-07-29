// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:shop_apllication_1/testimage.dart';
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   PlatformFile? pickedFile;
//   UploadTask? uploadTask;

//   Future<void> selectFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles();

//       if (result != null) {
//         setState(() {
//           pickedFile = result.files.first;
//         });
//         print("File selected: ${pickedFile!.name}");
//         await uploadFile(); // Начнем загрузку сразу после выбора файла
//       } else {
//         print("No file selected");
//       }
//     } catch (e) {
//       print("File selection failed: $e");
//     }
//   }

//   Future<void> uploadFile() async {
//     if (pickedFile == null) return;

//     try {
//       final path = 'photo/${pickedFile!.name}';
//       final file = File(pickedFile!.path!);

//       print("Uploading file to: $path");

//       final ref = FirebaseStorage.instance.ref().child(path);
//       uploadTask = ref.putFile(file);



//       final snapshot = await uploadTask!.whenComplete(() {});
//       final urlDownload = await snapshot.ref.getDownloadURL();

//       print('Download Link: $urlDownload');
//     } catch (e) {
//       print("File upload failed: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload File to Firebase Storage')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (pickedFile != null)
//               Expanded(
//                 child: Container(
//                   color: Colors.blue[100],
//                   child: Image.file(
//                     File(pickedFile!.path!),
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: selectFile,
//               child: Text('Select File'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
