// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, must_be_immutable

import 'package:book_notes/consts/consts.dart';

import "package:flutter/material.dart";

class MainPage extends StatefulWidget {
  /// To run without errors, You must make the parameters equel in length
  /// 
  /// pagesTitles.length == pages.length == icons.length
  /// 
  /// The title at index 0 well take page & icon at index 0, and so on.
  MainPage({Key? key, required this.pages, required this.pagesTitles, required this.icons, required this.iconSize}) : super(key: key);
  
  
  List<String> pagesTitles = [];
  List<Widget> pages = [];
  List<IconData> icons = [];
  double iconSize = 0;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentPageIndex = 0;

  List<Widget> bottomBarIcons(double iconSize){
    List<Widget> theIcons = [];
    for (var i = 0; i < widget.icons.length; i++) {
      theIcons.add(
        GestureDetector(
          child: Icon(
            widget.icons[i],
            size: iconSize,
            color: currentPageIndex == i? color3 : color1,
          ),
          onTap: () {
            setState(() {
              currentPageIndex = i;
            });
          },
        )
      );
    }
    return theIcons;
  }
  
  
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pagesTitles[currentPageIndex],
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: mediumfont),
        ),
        backgroundColor: color5,
        centerTitle: true,
      ),
      body: widget.pages[currentPageIndex],
      bottomNavigationBar: Container(
        height: widthconverter(180, screenwidth),
        color: color5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: bottomBarIcons(widthconverter(widget.iconSize, screenwidth))
        ),
      )
    );
  }
}
