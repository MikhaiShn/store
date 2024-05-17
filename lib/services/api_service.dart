import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/note.dart';

class ApiService {
//the domain from railwap app.
  static const String _baseUrl ="https://notesapp-api-produ";/**/
              
  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/add");
    var response = await http.post(requestUri, 
    body: note.toMap());//convert from object to map
    var decoded = jsonDecode(response.body);
    print(decoded.toString());
  }
  static Future<void> updateNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/update");
    var response = await http.put(requestUri,body: note.toMap());
    var decoded = jsonDecode(response.body);
    print(decoded.toString());
  }
  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/delete");
    var response = await http.delete(requestUri,body: note.toMap());
    var decoded = jsonDecode(response.body);
    print(decoded.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUri = Uri.parse("$_baseUrl/list/$userid");
    var response =await http.get(requestUri);
    List decoded = jsonDecode(response.body);
    return decoded.map((note)=>Note.fromMap(note)).toList();
  }
}