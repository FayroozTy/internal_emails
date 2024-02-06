//emailTransform
import 'dart:async';
import 'dart:convert';
import 'dart:io' as ui;
import 'dart:io';

import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_emails/Inbox/ui/InboxScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:substring_highlight/substring_highlight.dart';
import '../../Util/Constant.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../Util/network/logging.dart';
import '../Model/RecieverList.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class emailTransformScreen extends StatefulWidget{

  final String orderNo;

  final String orderDesc;
  final String recievingDate;
  final  List<Widget> imgList ;
  final String ContactPersonId;
  final String sender_Contact_Person_ID;


  emailTransformScreen(this.orderNo, this.orderDesc, this.recievingDate,this.imgList, this.ContactPersonId,this.sender_Contact_Person_ID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _emailTransformScreen(this.orderNo, this.orderDesc, this.recievingDate,this.imgList, this.ContactPersonId,this.sender_Contact_Person_ID);
  }

}

class _emailTransformScreen extends State<emailTransformScreen> {

  final String orderNo;
  final String ContactPersonId;
  final String sender_Contact_Person_ID;
  final  List<Widget> imgList ;

  _emailTransformScreen(this.orderNo, this.orderDesc, this.recievingDate,this.imgList , this.ContactPersonId,this.sender_Contact_Person_ID);

  final String orderDesc;
  final String recievingDate;
  bool _isLoading = false;
  var _commentsController = TextEditingController();
  List<RecieverList> recieverList = [];
  List<String> recievernameList = [];
  late TextEditingController controller;


  ui.File? imgFile;
  final imgPicker = ImagePicker();
  FilePickerResult? selectedfile;
  List<String> fileList = [];
  @override
  void initState() {

    super.initState();
    getRecieverList( this.ContactPersonId);

  }

  @override
  void dispose() {

    super.dispose();

  }


  getRecieverList(String ContactPersonId) async {



    setState(() {
      _isLoading = true;
    });
    // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');

    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      String LoginName  = prefs.getString("LoginName") ?? "";
      print(BaseURL_Login + "api/Transition/RecieverListByUserName/mkhbishawi");

      http.Response
      response = await http.get(Uri.parse(BaseURL_Login + "api/Transition/RecieverListByUserName/mkhbishawi"),
          headers: <String, String>{
        "Accept":
        "application/json",
        "Access-Control-Allow-Credentials":
        "*",
        "content-type":
        "application/json"
      });

      if (response.statusCode == 200) {
        print(response.body);
        var json = jsonDecode(response.body);

        setState(() {
          recieverList =
              (json as List).map((x) => RecieverList.fromJson(x))
                  .toList();
          for(var item in recieverList){
            print(item.contactPersonId);
            print(item.contactPersonName);
            recievernameList.add(item.contactPersonName.toString());
          }
          _isLoading = false;
        });
        print((recievernameList.length));
        for(var i in recievernameList){
          print(i);
        }

      }

      else{
        showAlertDialog( context , "" , "خطا في الاتصال");
        setState(() {
          _isLoading = false;
        });
      }   ///
    }

    catch (e) {
      print('Error : $e');
      showAlertDialog( context , "" , "خطا في الاتصال");
      setState(() {
        _isLoading = false;
      });
      return null;
    } finally {

    }
  }

  Transition(String order_ID,String notes, String comments) async {

    String recivername = controller.text;
    String reciverid = "";
   // print(recivername);

    for(var item in recieverList){
      print(item.contactPersonName);
      print(item.contactPersonId);
      if(item.contactPersonName ==recivername ){
        reciverid = item.contactPersonId.toString();
       // return;
      }
    }
    print(reciverid);

      setState(() {
        _isLoading = true;
      });
      // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');


      try {

        print({
          "order_ID": this.orderNo,
          "senderContactPersonId": this.sender_Contact_Person_ID,
          "recieverContactPersonId": reciverid,
          "newOrderStatusId": 3,
          "asCopy": false,
          "endCycle": false,
          "notes": notes,
          "userName": "admin",
          "comments": comments
        });

        http.Response
        response = await http.post(Uri.parse(BaseURL_Login + "api/Transition"), headers: <String, String>{
          "Accept":
          "application/json",
          "Access-Control-Allow-Credentials":
          "*",
          "content-type":
          "application/json"
        }, body: jsonEncode(<String, dynamic>{
          "order_ID": order_ID,
          "senderContactPersonId": this.sender_Contact_Person_ID,
          "recieverContactPersonId": reciverid,
          "newOrderStatusId": 3,
          "asCopy": false,
          "endCycle": false,
          "notes": notes,
          "userName": "admin",
          "comments": comments
        }),);


        SharedPreferences prefs =  await SharedPreferences.getInstance();

        if (response.statusCode == 200) {
          if(response.body.toString().contains('true')){
            showAlertDialog( context , "" , "تم التحويل بنجاح");

            setState(() {
              _isLoading = false;
            });
          }else{
            print('Add : ${response.body}');

            showAlertDialog( context , "" , "خطا في البيانات");
            setState(() {
              _isLoading = false;
            });

            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return InboxScreen();
            // }));

          }

        }
        else if (response.statusCode == 404){
          showAlertDialog( context , "" , "خطا في الاتصال");
          setState(() {
            _isLoading = false;
          });
        }


        else {

          showAlertDialog( context , "" , "خطا في البيانات");
          setState(() {
            _isLoading = false;
          });

        }
      }

      catch (e) {
        print('Error : $e');

        showAlertDialog( context , "" , "خطا في الاتصال");
        return null;
      } finally {

      }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: CustomColors.colorPrimary,
            title: Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                " تفاصيل المذكرة",
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),

        body:
        Padding(
          padding: EdgeInsets.all(15),
          child: ListView(

            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [

                    SizedBox(height: 5,),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                         this.recievingDate.split('T').first,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: "Al-Jazeera-Arabic-Regular"),
                        ),

                        Container(

                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                          width:100,
                          height: 30,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)
                            ),
                            color: CustomColors.colorpriority_1,

                          ),
                          alignment: Alignment.center,
                          child: Text(
                            this.orderNo,
                            style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: "Al-Jazeera-Arabic-Regular"),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        
                        Icon(Icons.add_circle_outline, color: Color(0xFF354366),),
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
                              "تحويل الى ",
                              softWrap: false),
                        ),
                      ],
                    ),

                   
                    SizedBox(height: 15),

                    Autocomplete(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        } else {
                          return recievernameList.where((word) => word
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
//1st row
                    SizedBox(height: 20),
                    Container (

                      width: MediaQuery.of(context).size.width*0.8,
                      padding: EdgeInsets.all(4),
                      child: Text(textScaleFactor: textScaleFactor,

                          textAlign: TextAlign.right,
                          maxLines: 20,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "Al-Jazeera-Arabic-Bold"),
                        this.orderDesc,
                          softWrap: false),
                    ),
                    SizedBox(height: 20),
                    _isLoading ?   Center(
                      child:
                      CircularProgressIndicator(),
                    ): Container(),
                    imgList.length > 0 ?
                    SizedBox(
                        height: 200,
                        child:
                        ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: imgList.length,
                          itemBuilder: (BuildContext context, int index) => Card(
                              child: imgList[index]
                          ),
                        )
                    ): Container(),

                    SizedBox(height: 20,),
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
                    Container (

                      width: MediaQuery.of(context).size.width*0.9,
                      padding: EdgeInsets.all(4),
                      child: Text(textScaleFactor: textScaleFactor,

                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "Al-Jazeera-Arabic-Regular"),
                          "تعليق",
                          softWrap: false),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: 45,

                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(


                            obscureText: false,
                            textAlign: TextAlign.right,
                            controller:_commentsController ,


                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (_newValue) {

                              setState(() {


                                  _commentsController.value = TextEditingValue(
                                    text: _newValue,
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: _newValue.length),
                                    ),
                                  );

                              });

                            },

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF7F7F7),
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              hintText:"",
                              border: InputBorder.none,

                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 35,
                          child: OutlinedButton(

                            child: Text(
                              textScaleFactor: textScaleFactor,"الغاء", style: TextStyle(color: Color(0xFF4A587A),fontFamily: "Al-Jazeera-Arabic-Bold"),),
                            style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.white
                            ),
                            onPressed: () {
                              setState(() {

                              });

                            },
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 35,
                          child: OutlinedButton(

                            child: Text(
                              textScaleFactor: textScaleFactor,"تحويل ", style: TextStyle(color: Colors.white,fontFamily: "Al-Jazeera-Arabic-Bold"),),
                            style: OutlinedButton.styleFrom(
                                primary: Color(0xFF4A587A),
                                backgroundColor: Color(0xFF4A587A)
                            ),
                            onPressed: () {
                              Transition(this.orderNo,this.orderDesc,_commentsController.text);

                            },
                          ),
                        ),
                      ],

                    ),



                  ],

                ),
              ),
            ],
          ),
        ));



  }

  showAlertDialog(BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("موافق"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  void openGalleryCamra( int flage ) async {
//galary
    if (flage == 1){

      var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
      setState(() {

        imgFile = ui.File(imgGallery!.path);
        final bytes = File(imgFile!.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        print(img64);
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