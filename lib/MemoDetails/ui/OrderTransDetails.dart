

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


class OrderTransDetails extends StatefulWidget{

  final String orderNo;
  final String reciever_Contact_Person_ID;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderTransDetails(this.orderNo,this.reciever_Contact_Person_ID);
  }

  OrderTransDetails(this.orderNo, this.reciever_Contact_Person_ID);
}

class _OrderTransDetails extends State<OrderTransDetails> {



  final String orderNo;
  final String reciever_Contact_Person_ID;
  List<OrderTrans> orderTrans = [];
  bool _isLoading = false;

  _OrderTransDetails(this.orderNo, this.reciever_Contact_Person_ID);

  @override
  void initState() {

    super.initState();
    print("orderid$orderNo");
    getListOrderTransComments( reciever_Contact_Person_ID,  orderNo);


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
          print(item.recieverContactPersonName);
        }




        setState(() {

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

        backgroundColor: Color(0xFFefe8df),
        appBar: AppBar(




            backgroundColor: CustomColors.colorPrimary,
            title: Center(
              child: Text(
                textScaleFactor: textScaleFactor,
                "كافة التعليقات",
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),



        body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: orderTrans.length,
            itemBuilder: (context,index) {
              return Container(
                height: 150,
                child: Card(

                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(

                    trailing: Icon(Icons.person),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0,top: 10),
                      child: Text(

                        orderTrans[index].senderContactPersonName,
                        textAlign: TextAlign.right,
                        style: TextStyle(  fontSize: 15,
                          color: Colors.black,

                          fontFamily: "Al-Jazeera-Arabic-Bold",),
                      ),
                    ),
                    subtitle:orderTrans[index].wantedFromReciever.toString()== "null" || orderTrans[index].wantedFromReciever.toString() == "" || orderTrans[index].wantedFromReciever.toString() ==null?

                    Text(

                      "لا تعليق",
                      textAlign: TextAlign.right,
                      style: TextStyle(  fontSize: 17,
                        color: Colors.black54,

                        fontFamily: "Al-Jazeera-Arabic-Regular",),
                    ): Text(

                      orderTrans[index].wantedFromReciever.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(  fontSize: 17,
                        color: Colors.black54,

                        fontFamily: "Al-Jazeera-Arabic-Regular",),
                    )



                  ),
                ),
              );
            },
          ),
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
