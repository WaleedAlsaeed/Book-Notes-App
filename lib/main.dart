// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:book_notes/pages/main_page.dart';
import "package:flutter/material.dart";
import 'package:book_notes/pages/titles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
        pages: [Titles(), AddTitle()],
        pagesTitles: const ["ملاحظاتك", "إضافة كتاب"],
        icons: [Icons.home_rounded, Icons.add],
        iconSize: 100,
      )
    );
  }
}