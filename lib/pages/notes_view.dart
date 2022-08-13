// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable
import 'package:flutter/material.dart';
import 'package:book_notes/consts/consts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../consts/book_info.dart';

//itdo: <-------------------- View All Notes For Selected Book -------------------->

class NotesView extends StatefulWidget {
  NotesView({Key? key, required this.book}) : super(key: key);
  Book book;
  
  @override
  // ignore: no_logic_in_create_state
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  double screenwidth = 0;
  
  bool isSelecting = false;
  List<int> selectedNotes = [];

  Widget theBook(String book) {
    return Container(
        padding: EdgeInsets.all(widthconverter(20, screenwidth)),
        margin: EdgeInsets.only(top: widthconverter(150, screenwidth), bottom: widthconverter(100, screenwidth)),
        width: widthconverter(950, screenwidth),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(widthconverter(50, screenwidth))),
            color: color4),
        child: Center(
          child: Text( 
            book,
            style: TextStyle(
              fontFamily: mediumfont,
              fontSize: widthconverter(80, screenwidth),
              color: color1,
            ),
            textDirection: TextDirection.rtl,
          )
        )
      );
  }

  final fieldController = TextEditingController();

  Widget addingNotePage(){
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: color2,
        child: SingleChildScrollView(
          child: Column(
          children: [
            Divider(thickness: 10, color: color5, height: widthconverter(200, screenwidth),),
            Column(
              children: [
                //itdo: مكان إدخال الملاحظة
                SizedBox(
                  width: widthconverter(950, screenwidth),
                  height: widthconverter(1000, screenwidth),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: fieldController,
                      maxLength: 400,
                      minLines: 11,
                      maxLines: 25,
                      style: TextStyle(
                        fontFamily: mediumfont,
                        fontSize: widthconverter(50, screenwidth)
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(  
                        contentPadding: EdgeInsets.all(widthconverter(30, screenwidth)),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                        fillColor: color1,
                        filled: true
                      ),
                    )
                  )
                ),
                //itdo: زر إضافة الملاحظة
                Container(
                  margin: EdgeInsets.only(top: widthconverter(90, screenwidth)),
                  child:
                    ElevatedButton(
                      //itdo: زر إضافة الملاحظة
                      onPressed: (){
                        if(fieldController.text.isNotEmpty){
                          setState(() {
                            addNote(widget.book.title, fieldController.text);
                          });
                          fieldController.clear();
                          showToastMessage(context, "لقد تمت إضافة ملاحظة", (_){setState(() => debugPrint("d"));});
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(widthconverter(450, screenwidth), widthconverter(125, screenwidth))
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widthconverter(30, screenwidth)),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(color5),
                      ),
                      child: Text(
                        "إضافة",
                        style: TextStyle(
                          color: color1,
                          fontFamily: mediumfont,
                          fontSize: widthconverter(55, screenwidth),
                        ),
                      ),
                    ),
                )
              ],
            )
          ]
        ))
      )
    );
  }



  @override
  Widget build(BuildContext context) {
    isSelecting = false;
    selectedNotes = [];
    screenwidth = MediaQuery.of(context).size.width;
    Future<List<dynamic>> notes = loadNotes(widget.book.title);
    return Scaffold(
      body: Container(
        color: color2,
        width: double.infinity,
        child: Column(
          children: [
            theBook(widget.book.title),
            Divider(thickness: 5, color: color5, height: 0,),
            FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data as List<dynamic>;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return NoteBlock(
                            index: index,
                            note: data[index],
                            isSelected: (value){
                              if(value){
                                if(!selectedNotes.contains(index)) {
                                  selectedNotes.add(index);
                                }
                              }
                              else {
                                selectedNotes.remove(index);
                              }
                              isSelecting = selectedNotes.isNotEmpty;
                            },
                            delete: (_) {
                              setState(() {
                                removeNote(widget.book.title, selectedNotes);
                              });
                            },
                          );
                        }
                      )
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(value: 0.5,),
                );
              },
              future: notes,
            ),
            Divider(thickness: 5, color: color5, height: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: widthconverter(120, screenwidth) * 1.5,
                    width: widthconverter(120, screenwidth) * 3,
                    child: Icon(Icons.arrow_back_rounded, size: widthconverter(120, screenwidth),),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(!isSelecting) {
                      showBarModalBottomSheet(
                        context: context, builder:(context) {
                          return addingNotePage();
                        }
                      );
                    }
                  },
                  child: SizedBox(
                    height: widthconverter(120, screenwidth) * 1.5,
                    width: widthconverter(120, screenwidth) * 3,
                    child: Icon(Icons.note_add_outlined, size: widthconverter(120, screenwidth),),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {}),
                  child: SizedBox(
                    height: widthconverter(120, screenwidth) * 1.5,
                    width: widthconverter(120, screenwidth) * 3,
                    child: Icon(Icons.refresh_rounded, size: widthconverter(120, screenwidth),),
                  ),
                )
              ],
            ),
          ],
        )
        
      ),
    );
  }
}

//itdo: <-------------------------------------------------------------------------->


class NoteBlock extends StatefulWidget {
  NoteBlock({Key? key, required this.index, required this.note, required this.isSelected, required this.delete}) : super(key: key);
  final ValueChanged<bool> isSelected;
  final ValueChanged<void> delete;
  String note;
  int index;
  @override
  State<NoteBlock> createState() => _NoteBlockState();
}

class _NoteBlockState extends State<NoteBlock> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () {
        if(isSelected) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('حذف الملاحظات',
                style: TextStyle(color: color5, fontFamily: boldfont),
                textDirection: TextDirection.rtl
              ),
              content: Text(
                'هل أنت متأكد من أنك تريد حذف الملاحظات من التطبيق؟\nلن تستطيع إستعادتها',
                style: TextStyle(color: color5, fontFamily: mediumfont),
                textDirection: TextDirection.rtl,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "تراجع",
                    style: TextStyle(color:Colors.red[500], fontFamily: mediumfont),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.delete(null);
                    Navigator.pop(context);
                    showToastMessage(context, "لقد تم حذف الملاحظات، أعد تحميل الصفحةإن لم تختفي الملاحظات", (_){});
                  },
                  child: Text(
                    'نعم، قم بالحذف',
                    style: TextStyle(fontFamily: mediumfont),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          );
        }
        
      },
      onTap: (){
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child:
      Container(
        padding: EdgeInsets.all(widthconverter(20, screenwidth)),
        margin: EdgeInsets.all(widthconverter(25, screenwidth)),
        width: widthconverter(900, screenwidth),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected? color4 : color1, width: widthconverter(20, screenwidth), style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(widthconverter(50, screenwidth))
          ),
          color: color1
        ),
        child: Text( 
            widget.note,
            style: TextStyle(
              fontFamily: mediumfont,
              fontSize: widthconverter(55, screenwidth),
              color: color5,
            ),
            textDirection: TextDirection.rtl,
          )
      )
    );
  }
}