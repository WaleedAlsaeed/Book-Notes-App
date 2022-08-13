// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers
import 'package:book_notes/consts/book_info.dart';
import 'package:book_notes/pages/notes_view.dart';
import 'package:flutter/material.dart';
import 'package:book_notes/consts/consts.dart';


//itdo: <--------------------- View All Books --------------------->

class Titles extends StatefulWidget {
  Titles({Key? key}) : super(key: key);

  @override
  State<Titles> createState() => _TitlesState();
}

class _TitlesState extends State<Titles> {
  double screenwidth = 0;
  
  Widget theBook(Book book, BuildContext context) {
    return GestureDetector(
      //itdo: عرض نافذة عند الضغط مطولا على الحاوية لحذف الكتاب
      onLongPress: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('حذف الكتاب',
              style: TextStyle(color: color5, fontFamily: boldfont),
              textDirection: TextDirection.rtl
            ),
            content: Text(
              'هل أنت متأكد من أنك تريد حذف كتاب "${book.title}" من التطبيق؟\nلن تستطيع إستعادة الملاحظات الخاصة بالكتاب',
              style: TextStyle(color: color5, fontFamily: mediumfont),
              textDirection: TextDirection.rtl,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "تراجع",
                  style: TextStyle(color: color5, fontFamily: mediumfont),
                  textDirection: TextDirection.rtl,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    removeTitle(book.title);
                    Navigator.pop(context);
                    showToastMessage(context, "لقد تم حذف ${book.title} من مجموعتك", (_){setState(() => debugPrint("d"));});
                  });
                },
                child: Text(
                  'نعم، قم بالحذف',
                  style: TextStyle(color:Colors.red[500], fontFamily: mediumfont),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        );
      },
      //itdo: الذهاب الى الملاحظات الخاصة بالكتاب
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return NotesView(book: book);
            }
          )
        );
      },

      //itdo: تصميم الحاوية التي تتضمن إسم الكتاب وكاتبه
      child: Container(
        padding: EdgeInsets.all(widthconverter(40, screenwidth)),
        margin: EdgeInsets.all(widthconverter(35, screenwidth)),
        width: widthconverter(950, screenwidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widthconverter(75, screenwidth))),
          color: color1
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //itdo: نص إسم الكتاب
            Text( 
              book.title,
              style: TextStyle(
                fontFamily: boldfont,
                fontSize: widthconverter(100, screenwidth),
                color: Colors.black,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            //itdo: نص إسم الكاتب
            Text(
              book.writer,
              style: TextStyle(
                fontFamily: mediumfont,
                fontSize: widthconverter(50, screenwidth),
                color: Colors.black,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;

    return Container(
      color: color2,
      //itdo: عرض جميع الكتب التي تمت إضافتها
      child: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //itdo: في حال حدوث خطأ
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            //itdo: عند نجاح قراءة الملف
            else if (snapshot.hasData) {
              final data = snapshot.data as List<dynamic>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return theBook(Book(data[index]["title"], data[index]["writer"]), context);
                }
              );
            }
          }
          //itdo: قيد التحميل
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: loadJson(),
      ),
    );
  }

}

//itdo: <---------------------------------------------------------->



//itdo: <-------------------- Add Book To App -------------------->

class AddTitle extends StatefulWidget {
  AddTitle({Key? key}) : super(key: key);

  @override
  State<AddTitle> createState() => _AddTitleState();
}

class _AddTitleState extends State<AddTitle> {

  double screenwidth = 0;

  final titleFieldKey = GlobalKey<FormState>(), writerFieldKey = GlobalKey<FormState>();
  final titleField = TextEditingController(), writerField = TextEditingController();

  Widget textinput(String label, TextEditingController controller, GlobalKey<FormState> formKey){
    //itdo: تصميم مكان كتابة معلومات الكتاب الذي سيتم إضافته
    return Container(
      margin: EdgeInsets.only(top: widthconverter(20, screenwidth), bottom: widthconverter(20, screenwidth)),
      width: widthconverter(950, screenwidth),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: mediumfont,
            fontSize: widthconverter(70, screenwidth),
            color: color1,
          ),
        ),
        SizedBox(
          width: widthconverter(950, screenwidth),
          child: Form(
            key: formKey,
            child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '*لقد نسيت ملئ هذه الخانة';
              }
              return null;
            },
            controller: controller,
            maxLength: 70,
            minLines: 1,
            maxLines: 4,
            style: TextStyle(
              fontFamily: mediumfont,
              fontSize: widthconverter(50, screenwidth)
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              errorStyle: TextStyle(color: color5),
              contentPadding:
                EdgeInsets.all(widthconverter(30, screenwidth)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none
              ),
              fillColor: color1,
              filled: true
            ),
          ))
        ),
      ],
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: color3,
      child: SingleChildScrollView(child: Column(
        children: [
          textinput("اسم الكتاب", titleField, titleFieldKey),
          textinput("اسم الكاتب", writerField, writerFieldKey),
          Container(
            margin: EdgeInsets.only(top: widthconverter(500, screenwidth)),
            child:
              ElevatedButton(
                onPressed: (){
                  if(titleFieldKey.currentState!.validate() && writerFieldKey.currentState!.validate()){
                    addBook(titleField.text, writerField.text);
                    showToastMessage(
                      context,
                      "لقد تمت إضافة كتاب ${titleField.text} لمجموعتك",
                      (_){setState(() => debugPrint("d"));}
                    );
                    titleField.clear();
                    writerField.clear();
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
                child: Text("إضافة",
                  style: TextStyle(
                    color: color1,
                    fontFamily: mediumfont,
                    fontSize: widthconverter(55, screenwidth),
                  ),
                ),
              ),
          )
        ],
      ))
    );
  }
}

//itdo: <---------------------------------------------------------->