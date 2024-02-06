


import 'dart:async';


import 'dart:io' as ui;

import 'package:substring_highlight/substring_highlight.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internal_emails/SentScreen/ui/SentScreen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../Util/Constant.dart';


class AddmemoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddmemoScreen();
  }
}

class _AddmemoScreen extends State<AddmemoScreen> {

  List<String> suggestons = ["محمد", "محمود", "خالد", "احمد", "امجد"];
  final TextEditingController _typeAheadController = TextEditingController();
  String? priority; //no radio button will be selected
  List<Widget> imgList = [];
  List<String> fileList = [];
  FilePickerResult? selectedfile;
  late TextEditingController controller;
  ui.File? imgFile;
  final imgPicker = ImagePicker();
  int _groupValue = -1;

  @override
  void initState() {

    super.initState();

  }

  @override
  void dispose() {

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(

            backgroundColor: CustomColors.colorPrimary,
            title: Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                "مذكرة جديدة",
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),

        body:
        ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container (

                    width: MediaQuery.of(context).size.width*0.8,
                    padding: EdgeInsets.all(4),
                    child: Text(textScaleFactor: textScaleFactor,

                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Al-Jazeera-Arabic-Bold"),
                        "الاسم ",
                        softWrap: false),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(

                        padding: const EdgeInsets.all(5),
                        width: 150,
                        margin: const EdgeInsets.only(left: 10, top: 10, right: 10),

                        height: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(2)
                          ),
                          color: Color(0xFFFBFBFB),
                          boxShadow: [
                            // BoxShadow(
                            //   color: Colors.grey,
                            //   blurRadius: 15.0, // soften the shadow
                            //   spreadRadius: 5.0, //extend the shadow
                            //   offset: Offset(
                            //     5.0, // Move to right 5  horizontally
                            //     5.0, // Move to bottom 5 Vertically
                            //   ),
                            // )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ' 11/11/2023 ',
                          style: TextStyle(fontSize: 13, color: Colors.black, fontFamily: "Al-Jazeera-Arabic-Regular"),
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 10, top: 10, right: 10),

                        height: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                              bottomLeft: Radius.circular(2),
                              bottomRight: Radius.circular(2)
                          ),
                          color: Color(0xFFFBFBFB),
                          boxShadow: [
                            // BoxShadow(
                            //   color: Colors.grey,
                            //   blurRadius: 15.0, // soften the shadow
                            //   spreadRadius: 5.0, //extend the shadow
                            //   offset: Offset(
                            //     5.0, // Move to right 5  horizontally
                            //     5.0, // Move to bottom 5 Vertically
                            //   ),
                            // )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'رقم المذكرة ',
                          style: TextStyle(fontSize: 13, color: Colors.black, fontFamily: "Al-Jazeera-Arabic-Regular"),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 15,),

                  Container (

                    width: MediaQuery.of(context).size.width*0.8,
                    padding: EdgeInsets.all(4),
                    child: Text(textScaleFactor: textScaleFactor,

                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Al-Jazeera-Arabic-Bold"),
                        "المرسل اليه ",
                        softWrap: false),
                  ),


                  Autocomplete(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      } else {
                        return suggestons.where((word) => word
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()));
                      }
                    },
                    optionsViewBuilder:
                        (context, Function(String) onSelected, options) {
                      return Material(
                        elevation: 4,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);

                            return ListTile(
                              // title: Text(option.toString()),
                              title: SubstringHighlight(
                                text: option.toString(),
                                term: controller.text,
                                textStyleHighlight: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(""),
                              onTap: () {
                                onSelected(option.toString());
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: options.length,
                        ),
                      );
                    },
                    onSelected: (selectedString) {
                      print(selectedString);
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onEditingComplete) {
                      this.controller = controller;

                      return SizedBox(
                        height: 40,
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 15,),

                  Container (

                    width: MediaQuery.of(context).size.width*0.8,
                    padding: EdgeInsets.all(4),
                    child: Text(textScaleFactor: textScaleFactor,

                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Al-Jazeera-Arabic-Bold"),
                        "البيان",
                        softWrap: false),
                  ),

                  SizedBox(
                    width: 400, // <-- TextField width
                    height: 120, // <-- TextField height
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(filled: true, hintText: ''),
                    ),
                  ),

                  SizedBox(height: 15,),

                  Container (

                    width: MediaQuery.of(context).size.width*0.8,
                    padding: EdgeInsets.all(4),
                    child: Text(textScaleFactor: textScaleFactor,

                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Al-Jazeera-Arabic-Bold"),
                        "الاولوية",
                        softWrap: false),
                  ),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue = value as int;

                                  });
                                },
                              ),
                              Text('مستعجل',style: TextStyle(
                                  color: Color(0xFF923731), fontFamily: "Al-Jazeera-Arabic-Regular",fontSize: 14
                              ),)
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue = value as int;

                                  });
                                },
                              ),
                              Text('متوسط',style: TextStyle(
                                  color: Color(0xFF4A587A), fontFamily: "Al-Jazeera-Arabic-Regular",fontSize: 14
                              ),)
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue = value as int;

                                  });
                                },
                              ),
                              Text('عادي', style: TextStyle(
                                  color: Color(0xFF295F56), fontFamily: "Al-Jazeera-Arabic-Regular",fontSize: 14
                              ),)
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      SizedBox(
                          width: 150,
                          height: 35,
                          child:
                          OutlinedButton.icon(

                            onPressed: () {showOptionsDialog( context ) ;},
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.white
                                ,backgroundColor: CustomColors.colorPrimary),
                            icon: const Icon(Icons.camera_alt),

                            label: const Text(''),
                          )

                      ),
                      SizedBox(
                          width: 150,
                          height: 35,
                          child:
                          OutlinedButton.icon(

                            onPressed: () {
                              selectFile();
                            },
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.white
                                ,backgroundColor: CustomColors.colorPrimary),
                            icon: const Icon(Icons.attach_file),

                            label: const Text(''),
                          )

                      ),
                    ],
                  ),

                  SizedBox(height: 20,),




                  imgList.length !=0 ?   SizedBox(
                      height: 100,
                      child:
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: imgList.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                            child: imgList[index]
                        ),
                      )
                  ):
                  Container(),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 35,
                        child: OutlinedButton(

                          child: Text(
                            textScaleFactor: textScaleFactor,"ارسال ", style: TextStyle(color: Colors.white,fontFamily: "Al-Jazeera-Arabic-Bold"),),
                          style: OutlinedButton.styleFrom(
                              primary: Color(0xFF4A587A),
                              backgroundColor: Color(0xFF4A587A)
                          ),
                          onPressed: () {
                            setState(() {

                            });


                          },
                        ),
                      ),
                    ],

                  ),


                ],

              ),
            ),
          ],

        )
    );
  }


  void openGalleryCamra( int flage ) async {
//galary
    if (flage == 1){

      var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
      setState(() {

        imgFile = ui.File(imgGallery!.path);
        imgList.add(Image.file(imgFile!, width: 100, height: 100));

      });
    }else{
      var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
      setState(() {

        imgFile = ui.File(imgCamera!.path);
        imgList.add(Image.file(imgFile!, width: 100, height: 100));


      });
    }

    //  Navigator.of(context).pop();
  }

  Future<void> showOptionsDialog(BuildContext context ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pictures Option"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(" Camera"),
                    onTap: () {
                      openGalleryCamra(2);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text(" Gallery"),
                    onTap: () {
                      openGalleryCamra(1);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  selectFile() async {
    selectedfile  = await FilePicker.platform.pickFiles(
      type: FileType.any,


    );

    if(selectedfile! != null ){

      PlatformFile file = selectedfile!.files.first;
      print('File Name: ${file?.name}');
      print('File Size: ${file?.size}');
      print('File Extension: ${file?.extension}');
      print('File Path: ${file?.path}');
      String filename = '${file?.name}';

      fileList.add(filename);

      imgList.add(Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.yellow[80],
            border: Border.all(
              color: Colors.black,
              width: 1,
            )),

        child:InkWell(
          onTap: (){

            //print(fileList);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              filename.contains('pdf')  ? Image.asset('assets/pdf.png',height: 60,width: 60,):
              filename.contains('docx')? Image.asset('assets/word.png',height: 60,width: 60,):
              filename.contains('xlsx')? Image.asset('assets/excel.png',height: 60,width: 60,):
              Icon(Icons.file_copy),
              SizedBox(height: 1,),
              Center(child: Text('${file?.name}',style: TextStyle(fontSize: 12),)),


            ],
          ),
        )


        ,
      ));




    }





    setState((){}); //update the UI so that file name is shown
  }



}
