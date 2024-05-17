import 'package:flutter/material.dart';
import 'package:shop_apllication_1/services/api_service.dart';

import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  //We will fetch notes from api later on
  List<Note> notes = [];
  bool isLoading = true;

  NoteProvider(){
    fetchNotes();
  }

  void addNote(Note note){
    notes.add(note);
    notifyListeners();
    ApiService.addNote(note);
  }

  void updateNote(Note note){
    int indexOfNote=
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote]=note;
    notifyListeners();
    ApiService.updateNote(note);
  }

  void deleteNote(Note note){
    int indexOfNote=
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes() async {
    List<Note> fetchedNotes =await ApiService.fetchNotes('polzovatel');
    notes = fetchedNotes.reversed.toList();
    isLoading=false;
    notifyListeners();
  }

}