// import 'package:flutter/material.dart';
// import 'package:shop_apllication_1/providers/notes_provider.dart';

// class AddNewNote extends StatefulWidget{
//   const AddNewNote({super.key});

//   @override
//   State<AddNewNote> createState() => _AddNewNoteState();
// }

// class _AddNewNoteState extends State<AddNewNote>{
//   TextEditingController titleController =TextEditingController();
//   TextEditingController noteController = TextEditingController();

//   @override
//   void dispose(){
//     //TODO: implement dispose
//     super.dispose();
//     titleController.dispose();
//     noteController.dispose();
//   }

//   void AddNewNote(){
//     if(titleController.text.trim().isEmpty){
//       ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Title cannot be empty!")));
//       return;
//     }
//     Note newNote = Note(
//       id:const Uuid().v1(),//Create uniqe ids
//       userid: "polzovatel",
//       title: titleController.text,
//       content: noteController.text,
//       dateadded: DateTime.now()
//     );
//     Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Note Added Succesfully!")));
//     Navigator.pop(context);

//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: (){
//             AddNewNote();
//           }, 
//           icon: const Icon(
//             Icons.note_add,
//             color: Colors.green,
//             size: 30,
//           ))
//         ],),
//     )
//   }
// }