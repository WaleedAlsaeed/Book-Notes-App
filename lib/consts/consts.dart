// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';




Future<File> filee()  async{
  final Directory directory = await getApplicationDocumentsDirectory();
  //debugPrint(directory.path);
  File file = File("${directory.path}/nnnn.mt3");

  if(await file.exists()){
    return file;
  }
  file.createSync();
  return file;
}

void removeNotes(){
  writeJson(jsonEncode([]));
}

Future<String> fileeContent() async{
  final File file = await filee();
  
  return await file.readAsString();
}

Future<List<dynamic>> loadJson() async{
  if((await fileeContent()).isNotEmpty){
    //debugPrint(jsonDecode(await fileeContent()).toString());
    return jsonDecode(await fileeContent());
  }
  return [];
}

Future<List<dynamic>> loadNotes(String title) async{
  var aa = await loadJson();
  var notes = [];
  for (var i = 0; i < aa.length; i++) {
    if(aa[i]["title"] == title){
      notes = aa[i]["notes"];
      break;
    }
  }
  return notes;
}


void writeJson(String str){
  filee().then((value) => value.writeAsStringSync(str));
}

void addBook(String title, String writer) async{
  List<dynamic> myJson = await loadJson();

  myJson.add({"title": title, "writer": writer, "notes": []});
  debugPrint(await fileeContent());
  writeJson(jsonEncode(myJson));
  debugPrint(await fileeContent());
}

void addNote(String title, String note) async{
  List<dynamic> myJson = await loadJson();

  for (var i in myJson) {
    if(i["title"] == title){
      i["notes"].add(note);
    }
  }
  writeJson(jsonEncode(myJson));
}

void removeNote(String title, List<int> indexes) async{
  List<dynamic> myJson = await loadJson();
  
  for (var i in myJson) {
    if(i["title"] == title){
      List<String> notes = List<String>.from(i["notes"]);
      for(var x in indexes){
        if(x < notes.length){
          notes[x] = "";
        }
      }
      notes.removeWhere((element) => element.isEmpty);
      i["notes"] = List<dynamic>.from(notes);
      break;
    }
  }
  writeJson(jsonEncode(myJson));
}

void removeTitle(String title) async{
  List<dynamic> myJson = await loadJson();
  for (int i = 0; i < myJson.length; i++) {
    if(myJson[i]["title"] == title){
      myJson.removeAt(i);
    }
  }
  writeJson(jsonEncode(myJson));
}

Color color5 = Color(0xFF03045E);
Color color4 = Color(0xFF0077B6);
Color color3 = Color(0xFF00B4D8);
Color color2 = Color(0xFF90E0EF);
Color color1 = Color(0xFFCAF0F8);

String boldfont = "Dubai-Bold";
String mediumfont = "Dubai-Medium";

double widthconverter(double number, double width){
  return (number * width) / 1080;
}

void showToastMessage(BuildContext context, String text, ValueChanged<void> onShow) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text, textDirection: TextDirection.rtl,),
      onVisible: () => onShow(null),
      duration: Duration(seconds: 2),
    ),
  );
}