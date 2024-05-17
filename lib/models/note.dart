
import 'package:flutter/foundation.dart';

class Note {
  String? id;
  String? userid;
  String? title;
  String? conntent;
  DateTime? dateadded;
}

  Note({this.id, this.userid, this.title, this.content, this.dateadded});

  Factory Note.fromMap(Map<String, dynamic){
    return Note(
      id: Map['id'],
      userid: Map['userid'],
      title: Map['title'],
      content: Map['conntent'],
      dateadded: DateTime.tryParse(Map['dateadded']));
  }

    Map<String,dynamic>
  