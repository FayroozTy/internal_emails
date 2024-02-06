

import 'dart:async';
import 'dart:convert';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:io' as ui;

import 'package:substring_highlight/substring_highlight.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:internal_emails/SentScreen/ui/SentScreen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../EmailTransfere/ui/emailTransform.dart';
import '../../Util/Constant.dart';
import '../Model/OrderTrans.dart';
import '../Model/attachment.dart';
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'OrderTransDetails.dart';


class memoDetailsScreen extends StatefulWidget{
  final String orderNo;
  final String citizenName;
  final String orderDesc;
  final String recievingDate;
  final String ContactPersonId;
  final String sender_Contact_Person_ID;
  final String wanted_From_Reciever;
  final String contact_Person_Name;
  final String reciever_Contact_Person_ID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _memoDetailsScreen(this.orderNo, this.citizenName, this.orderDesc,
        this.recievingDate, this.ContactPersonId,this.sender_Contact_Person_ID,this.wanted_From_Reciever,this.contact_Person_Name,this.reciever_Contact_Person_ID);
  }

  memoDetailsScreen(
      this.orderNo, this.citizenName, this.orderDesc, this.recievingDate,
      this.ContactPersonId,this.sender_Contact_Person_ID,this.wanted_From_Reciever,this.contact_Person_Name,this.reciever_Contact_Person_ID);


}

class _memoDetailsScreen extends State<memoDetailsScreen> {
  final String orderNo;
  final String citizenName;
  final String orderDesc;
  final String recievingDate;
  bool _isLoading = false;
  List<Attachment> attachment = [];
  final String ContactPersonId;
  final String sender_Contact_Person_ID;
  final String wanted_From_Reciever;
  final String contact_Person_Name;
  List<OrderTrans> orderTrans = [];
  List<OrderTrans> orderTransList = [];
  final String reciever_Contact_Person_ID;




  int _groupValue = -1;
  int groupid = 1;
  List<Widget> imgList = [
  ];

  final NetworkimgList = [
  ];

  final documentList = [
  ];
  List<Widget> imgAttach = [
  ];

  _memoDetailsScreen(
      this.orderNo, this.citizenName, this.orderDesc, this.recievingDate
      ,this.ContactPersonId,this.sender_Contact_Person_ID,this.wanted_From_Reciever,
      this.contact_Person_Name,this.reciever_Contact_Person_ID);
  @override
  void initState() {

    super.initState();
    imgList= [];
    imgAttach= [];
    getAttachList();

  }


  Future<void> _launchUrl(Uri _url) async {

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  getAttachList() async {



    setState(() {
      _isLoading = true;
    });
    // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');

    try {

      http.Response
      response = await http.get(Uri.parse(BaseURL_Login + "api/Memos/Attachments/$orderNo"), headers: <String, String>{
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


        attachment =
            (json as List).map((x) => Attachment.fromJson(x))
                .toList();

        for (var item in attachment) {
          String fileurl = item.fileUrl.toString();
          String docId = item.documentId.toString();

          if(fileurl.contains("png") ||fileurl.contains("jpg") ){
            NetworkimgList.add(NetworkImage("$fileurl"))  ;
            documentList.add(docId);

            imgList.add(Container(
              width: 100,
              height: 150,
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

                    GestureDetector(
                        onLongPress: () async {
                          // print("ll");
                          // print("$fileurl");
                          // final url = "$fileurl";
                          // await Share.share('${url}');

                        },
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return DetailScreen(NetworkimgList,imgList.length);
                          }));
                        },
                        child: CachedNetworkImage(
                          imageUrl: "$fileurl",
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),

                        )),



                  ],
                ),
              )


              ,
            ));



          }
          else{
            //pdf, ......

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
                onLongPress: () async {
                  // print("doc");
                  // print("$fileurl");
                  // final url = "$fileurl";
                  // await Share.share('${url}');

                },
                onTap: (){
                  print("click");
                  _launchUrl(Uri.parse(fileurl));
                  //print(fileList);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    fileurl.contains('pdf')  ? Image.asset('assets/pdf.png',height: 60,width: 60,):
                    fileurl.contains('docx')? Image.asset('assets/word.png',height: 60,width: 60,):
                    fileurl.contains('xlsx')? Image.asset('assets/excel.png',height: 60,width: 60,):
                    Icon(Icons.file_copy),
                    SizedBox(height: 1,),
                    Center(child: Text('${docId}',style: TextStyle(fontSize: 12),)),


                  ],
                ),
              )


              ,
            ));


          }



        }


        setState(() {
          imgAttach = imgList;
          _isLoading = false;
        });
        getListOrderTransComments( reciever_Contact_Person_ID, orderNo );
      }

      else{
        setState(() {
          _isLoading = false;
        });
        getListOrderTransComments( reciever_Contact_Person_ID, orderNo );

      }
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


  getListOrderTransComments(String reciever_Contact_Person_ID, String orderid) async {

    setState(() {
      _isLoading = true;
    });
    // _showDialog(context, SimpleFontelicoProgressDialogType.normal, '');

    try {

      http.Response
      response = await http.get(Uri.parse(BaseURL_Login + "api/Transition/OrderTrans/$reciever_Contact_Person_ID/$orderid"), headers: <String, String>{
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


        orderTrans =
            (json as List).map((x) => OrderTrans.fromJson(x))
                .toList();
        for(var item in orderTrans){
          print("item.recievingDate");
          if(item.senderContactPersonName !="."){
            orderTransList.add(item);
          }
          print(item.recievingDate);

        }
        setState(() {
        orderTransList.sort((a, b) => a.recievingDate!.compareTo(b.recievingDate!));
        orderTransList = orderTransList..reversed.toList();






          _isLoading = false;
        });
      }

      else{
        setState(() {
          _isLoading = false;
        });
      }
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











  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

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



        body:ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  _isLoading ?   Center(
                    child:
                    CircularProgressIndicator(),
                  ): Container(),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        this.recievingDate.split("T").first,
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

                  SizedBox(height: 20), //1st row

                  //2d row
                  Container (

                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.all(4),
                    child: Text(textScaleFactor: textScaleFactor,

                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Al-Jazeera-Arabic-Bold"),
                        this.citizenName,
                        softWrap: false),
                  ),
                  SizedBox(height: 8), //1st row

                  //2d row
                  Container (

                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.all(4),
                    child: Text(textScaleFactor: textScaleFactor,

                        textAlign: TextAlign.right,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: "Al-Jazeera-Arabic-Regular"),
                        orderDesc,
                        softWrap: false),
                  ),
                  SizedBox(height: 25),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,


                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(textScaleFactor: textScaleFactor,
                            " : " + contact_Person_Name,
                            style: TextStyle(
                              fontSize: 15,

                              overflow: TextOverflow.ellipsis,
                              color: Color(0xFF295F56),
                              fontFamily: "Al-Jazeera-Arabic-Bold",
                              decoration: TextDecoration.underline,

                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: (){

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xFFefe8df),

                                    content: setupalertdialoadcontainer(wanted_From_Reciever,1),
                                  );
                                });


                          },
                          child: wanted_From_Reciever== "null" || wanted_From_Reciever == "" || wanted_From_Reciever ==null?

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(textScaleFactor: textScaleFactor,
                                    'التفاصيل',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontFamily: "Al-Jazeera-Arabic-Bold",
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(textScaleFactor: textScaleFactor,
                                      "لا تعليق",
                                      style: TextStyle(
                                        fontSize: 15,

                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontFamily: "Al-Jazeera-Arabic-Bold",


                                      ),
                                      maxLines: 2,
                                      softWrap: true,
                                    ),
                                  ) ,

                                ],
                              ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(textScaleFactor: textScaleFactor,
                              'التفاصيل',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontFamily: "Al-Jazeera-Arabic-Bold",
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 200,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(textScaleFactor: textScaleFactor,
                                  wanted_From_Reciever,
                                  style: TextStyle(
                                    fontSize: 15,

                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontFamily: "Al-Jazeera-Arabic-Bold",


                                  ),
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ),

                          ],),





                        ),




                      ],
                    ),
                  ),








                  SizedBox(height: 20),
                  imgAttach.length > 0 ?

                  SizedBox(
                      height: 200,
                      child:
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: imgAttach.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                            child: imgAttach[index]
                        ),
                      )
                  ): Container(),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(

                        height: 35,
                        width: 120,
                        child: OutlinedButton(

                          child: Text(
                            textScaleFactor: textScaleFactor,"تحويل     ", style: TextStyle(color: Colors.white,fontFamily: "Al-Jazeera-Arabic-Bold"),),
                          style: OutlinedButton.styleFrom(
                              primary: Color(0xFF4A587A),
                              backgroundColor: Color(0xFF4A587A)
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return emailTransformScreen(this.orderNo,this.orderDesc,this.recievingDate,this.imgList,this.ContactPersonId,this.sender_Contact_Person_ID);
                              }));
                            });


                          },
                        ),
                      ),
                      SizedBox(

                        height: 35,
                        child: OutlinedButton(

                          child: Text(
                            textScaleFactor: textScaleFactor,"تحويل نسخة ", style: TextStyle(color: Color(0xFF4A587A),fontFamily: "Al-Jazeera-Arabic-Bold"),),
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


                    ],

                  ),

                ],

              ),
            ),
          ],

        )
    );


  }



  _showAlertDialog() {
    final SetListTiles _setListTiles = new SetListTiles(
      groupid: groupid,
    );



    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text('تحويل',style: TextStyle(
            color: Colors.black, fontFamily: "Al-Jazeera-Arabic-Regular",fontSize: 16
        ),),
      ),
      content: new SingleChildScrollView(
        child: Column(
          children: [
            _setListTiles,
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 35,
              child: OutlinedButton(

                child: Text(
                  textScaleFactor: textScaleFactor,"التالي ", style: TextStyle(color: Colors.white,fontFamily: "Al-Jazeera-Arabic-Bold"),),
                style: OutlinedButton.styleFrom(
                    primary: Color(0xFF4A587A),
                    backgroundColor: Color(0xFF4A587A)
                ),
                onPressed: () {
                  setState(() {
                    print('groupTransfere$groupTransfere');

                    if(groupTransfere == 1){

                      Navigator.pop(context);

                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return emailTransformScreen(this.orderNo,this.orderDesc,this.recievingDate,this.imgList,this.ContactPersonId,this.sender_Contact_Person_ID);
                      }));

                    }
                    else{


                    }



                  });


                },
              ),
            ),
          ],

        ),
        SizedBox(height: 10,)
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

  Widget setupalertdialoadcontainer(String wanted_From_Reciever, int itemCount) {

    return

      Container(
        color: Color(0xFFefe8df),
       height:MediaQuery.of(context).size.height - 5, // change as per your requirement
       width: MediaQuery.of(context).size.width -5,

        child:

        ListView.builder(
          itemCount: orderTransList.length,
          itemBuilder: (context,index) {
            return Container(
              height: 170,
              child:
                  Card(

                    elevation: 9,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child:
                        Column(
                          children: [

                            ListTile(

                              trailing: Icon(Icons.person),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0,top: 4),
                                child:
                                Text(

                                  orderTransList[index].senderContactPersonName,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(  fontSize: 14,
                                    color: Colors.black,

                                    fontFamily: "Al-Jazeera-Arabic-Bold",),
                                ),
                              ),
                              subtitle:
                              orderTransList[index].wantedFromReciever.toString()== "null" || orderTransList[index].wantedFromReciever.toString() == "" || orderTransList[index].wantedFromReciever.toString() ==null?
                              Text(

                                "لا تعليق",
                                textAlign: TextAlign.right,
                                style: TextStyle(  fontSize: 14,
                                  color: Colors.black54,

                                  fontFamily: "Al-Jazeera-Arabic-Regular",),
                              ):
                              Text(

                                orderTransList[index].wantedFromReciever.toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(  fontSize: 14,
                                  color: Colors.black54,

                                  fontFamily: "Al-Jazeera-Arabic-Regular",),
                              )
                              ,



                            ),
                            SizedBox(height: 15,),

                            Padding(
                              padding:EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text( orderTransList[index].recievingDate.split("T").first, textAlign: TextAlign.right,
                                  style: TextStyle(  fontSize: 14,
                                    color: Colors.black54,

                                    fontFamily: "Al-Jazeera-Arabic-Regular",),),
                              ),
                            )
                          ],
                        )

                  )

       ,
            );
          },
        ),
      );
  }
  showAlertDialog(BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("موافق"),
      onPressed: () {
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
}


class SetListTiles extends StatefulWidget {
  int groupid ;
  SetListTiles({ required this.groupid}) ;

  @override
  _SetListTilesState createState() => _SetListTilesState(groupid);
}

class _SetListTilesState extends State<SetListTiles> {

  int groupid ;
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        ListTile(
          title:Text('تحويل ', style: TextStyle(
              color: Colors.black, fontFamily: "Al-Jazeera-Arabic-Regular",fontSize: 14
          ),),
          leading: new Radio(
            value: 1,
            groupValue: groupid,
            onChanged: (value) {
              setState(() {
                groupTransfere = 1;
                print(groupid);
                groupid = value as int;

              });
            },
          ),
        ),
        ListTile(
          title: Text('ارسال نسخة', style: TextStyle(
              color: Colors.black, fontFamily: "Al-Jazeera-Arabic-Regular",fontSize: 14
          ),),
          leading: new Radio(
            value: 2,
            groupValue: groupid,
            onChanged: (value) {
              setState(() {
                groupTransfere = 2;
                print(groupid);
                groupid = value as int;

              });
            },
          ),
        ),

      ],
    );
  }

  _SetListTilesState(this.groupid);
}


class DetailScreen extends StatefulWidget {
  final  imgList;
  final count;
  // final  docList;
  DetailScreen(this.imgList, this.count);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailScreen(this.imgList, this.count);
  }
}
class _DetailScreen extends State<DetailScreen> {
//  final String fileurl;


  final  imgList;
  // final  docList;
  final count;
  _DetailScreen(this.imgList,this.count);
  late int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              //menu icon button at start left of appbar
              onPressed: () {
                Navigator.pop(context);
                //code to execute when this button is pressed
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),




            backgroundColor: CustomColors.colorPrimary,
            title: Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                " تفاصيل ",
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),
        body:


        Stack(
          children: [


            PhotoViewGallery.builder(
              itemCount: count,
              builder: (BuildContext context, int index) {

                return PhotoViewGalleryPageOptions(
                  imageProvider: imgList[index],
                  initialScale: PhotoViewComputedScale.contained ,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                  onTapUp: (_, __, ___)  async {

                    //
                    // final url = imgList[index];
                    // await Share.share('${url}');
                  },


                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator(),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              onPageChanged: onPageChanged,



            ),

            // count > 1 ? Container(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Icon(Icons.arrow_back_ios_rounded,color: Colors.grey,),
            //       SizedBox(width: 10,),
            //       Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,),
            //
            //     ],
            //   ),
            // ): Container()
            // // Container(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Text(
            //     "documentId: ${docList[currentIndex + 1]}",
            //     style: const TextStyle(
            //       color: CustomColors.colorpriority_1,
            //       fontSize: 14.0,
            //       decoration: null,
            //     ),
            //   ),
            // ),
          ],

        )
    );
  }
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}