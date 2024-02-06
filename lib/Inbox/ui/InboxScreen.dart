

import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_emails/Addmemo/ui/Addmemo.dart';
import 'package:internal_emails/Login/ui/loginScreen.dart';
import 'package:internal_emails/MemoDetails/ui/memoDetailsScreen.dart';
import 'package:internal_emails/SentScreen/ui/SentScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Draft/ui/DraftScreen.dart';
import '../../Util/Constant.dart';
import '../../Util/network/logging.dart';
import '../Model/ContactLogins.dart';
import '../Model/Memo.dart';
import '../bloc/Memo/Memo_bloc.dart';
import '../bloc/Memo/Memo_event.dart';
import '../bloc/Memo/Memo_state.dart';
import '../repository/MemoServive.dart';


class InboxScreen extends StatefulWidget{
  final int contactId;

  InboxScreen(this.contactId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InboxScreen(this.contactId);
  }

}

class _InboxScreen extends State<InboxScreen> {
  final int contactId;

  _InboxScreen(this.contactId);

  bool _isLoading = false;

  List<ContactLogins> contactLogins = [];
  List<Memo> memoData = [];
  List<Memo> memoDataSearch = [];
  List<Memo> itemPriorityList_1= [];
  List<Memo> itemPriorityList_2= [];
  List<String> itemSeachList = [];
  List<Memo> itemDateAscList = [];
  String LoginName = "";
  int  listAscDes= 10;

  final MemoBloc _sentMemoBloc = MemoBloc(MemoRepository());
  var _searchcontroller = TextEditingController();

  @override
  void initState() {

    super.initState();
    getname();


    listAscDes= 10;

    BlocProvider.of<MemoBloc>(
        context).add(SendData(
        contactId,1));

    // getMemos(this.contactId);

  }

  getname() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    setState(() {
      LoginName = prefs.getString("LoginName") ?? "";
    });


  }
  @override
  void dispose() {

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(

        // backgroundColor: Color(0xFFC1C1C1),
          appBar: AppBar(
              automaticallyImplyLeading: false,


              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],



              backgroundColor: CustomColors.colorPrimary,
              title: Center(
                child: Text(
                  textScaleFactor: textScaleFactor,
                  "البريد الوارد ",
                  style:  Theme.of(context).textTheme.barTextStyles,
                ),
              )),

          endDrawer:    Drawer(

            backgroundColor: CustomColors.colorPrimaryDark,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(

                        child: Column(
                          //  mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,

                                  children: [
                                    SizedBox(height: 15,),

                                    Text(
                                      textScaleFactor: textScaleFactor,
                                      LoginName,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFFF1F1F1),
                                          fontFamily:
                                          "Al-Jazeera-Arabic-Bold"),
                                    ),





                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.person,color: Colors.white,size: 60,)
                              ],
                            ),



                          ],
                        ),

                      ),




                      CustomListTile('مذكرة جديدة', "new"),
                      CustomListTile('البريد الصادر', "sent"),
                      CustomListTile('الارشيف', "draft"),





                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child:

                  InkWell(
                    onTap: () async {


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() {
                        prefs.setString("isLogin", "false");

                        prefs.setString("LoginName", "");
                        prefs.setBool("VerifyLogin", false);

                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => loginPage()));

                        //   Navigator.pop(context);

                      });

                    },
                    child: Container(
                      // This align moves the children to the bottom
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            // This container holds all the children that will be aligned
                            // on the bottom and sh
                            //
                            // the above ListView
                            child:
                            Container(

                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              width:180,
                              height: 30,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)
                                ),
                                color: Color(0xFFFEFEFE),
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
                                ' تسجيل الخروج',
                                style: TextStyle(fontSize: 13, color: CustomColors.colorPrimary, fontFamily: "Al-Jazeera-Arabic-Regular"),
                              ),
                            )
                        )),
                  ),
                )
              ],
            ),
          ),

          floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,

          floatingActionButton:listAscDes == 5 || listAscDes == 25 || listAscDes == 35 ||listAscDes == 85 ||listAscDes ==
              15?
          FloatingActionButton(
            backgroundColor: Color(0xFF923731),
            onPressed: () {

              setState(() {
                _searchcontroller.text = "";
                listAscDes= 10;
              });


              BlocProvider.of<MemoBloc>(
                  context).add(SendData(
                  contactId,1));},

            child: Text("الرئيسية",style: TextStyle(color: Colors.white,fontSize: 13,
                fontFamily:
                "Al-Jazeera-Arabic-Regular")),):Container(),

          body:
          BlocConsumer<MemoBloc, MemoState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is MemoLoaded) {
                print(state.data.body);

                if(state.data.body.contains("[]") ){


                  return buildmainlayout();

                }else{
                  memoData = [];
                  itemSeachList = [];
                  itemDateAscList = [];
                  String jsonsDataString = state.data.body.toString();
                  // toString of Response's body is assigned to jsonDataString
                  String receivedJson = jsonsDataString;



                  List<Memo> responseobj =  (jsonDecode(jsonsDataString)as List).map((x) => Memo.fromJson(x))
                      .toList();
                  memoData = responseobj;
                  itemDateAscList = memoData;
                  print("memoData.l");

                  print(memoData.length);


                  print("itemDateAscList.l");

                  print(itemDateAscList.length);

                  for(var items in memoData){
                    String item = items.orderNo.toString() + "/" + items.citizenName.toString();

                    itemSeachList.add(item);
                  }
                  for(var items in memoData){
                    if(items.order_Priority == 1){
                      itemPriorityList_1.add(items);
                    }
                    else if(items.order_Priority == 0){
                      itemPriorityList_2.add(items);
                    }
                  }


                  itemDateAscList.sort((a, b) => a.recievingDate!.compareTo(b.recievingDate!));

                  for(var x in itemDateAscList){
                    print(x.citizenName);
                    print(x.recievingDate);
                  }

                  print("ff");
                  print(listAscDes);

                  if(listAscDes == 0){
                    return  buildReturnlayout( itemPriorityList_1);

                    return buildReturnlayout(  itemDateAscList.reversed.toList());
                  }
                  else if (listAscDes == 5){
                    memoDataSearch.sort((a, b) => a.recievingDate!.compareTo(b.recievingDate!));
                    return   buildReturnlayout(memoDataSearch.reversed.toList());
                  }
                  else if (listAscDes == 1){
                    return  buildReturnlayout( itemPriorityList_2);

                    //  return  buildReturnlayout( itemDateAscList);
                  }

                  else if (listAscDes == 2){

                    return buildReturnlayout(  itemDateAscList);
                  }
                  else if (listAscDes == 3){

                    return  buildReturnlayout( itemDateAscList.reversed.toList());
                  }


                  else if(listAscDes == 25){
                    listAscDes = 5;
                    return   buildReturnlayout(memoDataSearch);
                  }


                  else if(listAscDes == 35){
                    listAscDes = 5;
                    return   buildReturnlayout(memoDataSearch.reversed.toList());
                  }

                  else if(listAscDes == 85){
                    print("fjhfuhf");
                    listAscDes = 5;
                    print(memoDataSearch.length);
                    itemPriorityList_1 = [];
                    itemPriorityList_2 = [];

                    for(var items in memoDataSearch){
                      print(items.citizenName);
                      if(items.order_Priority == 1){
                        itemPriorityList_1.add(items);
                      }
                      else if(items.order_Priority == 0){
                        itemPriorityList_2.add(items);
                      }
                    }

                    return   buildReturnlayout(itemPriorityList_1);
                  }


                  else if(listAscDes == 15){
                    listAscDes = 5;
                    print("nnigi");

                    itemPriorityList_1 = [];
                    itemPriorityList_2 = [];
                    for(var items in memoDataSearch){
                      print(items.citizenName);
                      if(items.order_Priority == 1){
                        itemPriorityList_1.add(items);
                      }
                      else if(items.order_Priority == 0){
                        itemPriorityList_2.add(items);
                      }
                    }


                    return   buildReturnlayout(itemPriorityList_2);
                  }


                  else{
                    return buildReturnlayout( itemDateAscList.reversed.toList());
                  }





                }


              }

              else if (state is MemoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return
                  buildmainlayout();
              }
            },

          )




      ),
    );
  }

  buildReturnlayout(List<Memo>  returnData) {
    return
      Column(
        children: [
          SizedBox(height: 10,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              PopupMenuButton(
                icon: Image.asset('assets/filter.png'),
                onSelected: (value) {
                  // your logic
                  if (value == 0){

                    print("listAscDes");
                    print(listAscDes);

                    if(listAscDes == 5){
                      print("kn");

                      setState(() {
                        listAscDes = 85;
                        print("de");
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }else{

                      setState(() {
                        listAscDes = 0;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }




                  }
                  else if (value == 1){

                    print("listAscDes");
                    print(listAscDes);


                    if(listAscDes == 5){
                      print("kn");
                      setState(() {
                        listAscDes = 15;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }else{

                      setState(() {
                        listAscDes = 1;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }






                  }

                  else if (value == 2){

                    if(listAscDes == 5){
                      setState(() {
                        listAscDes = 25;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }else{
                      setState(() {
                        listAscDes = 2;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }





                  }

                  else if (value == 3){

                    if(listAscDes == 5){
                      setState(() {
                        listAscDes = 35;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }else{
                      setState(() {
                        listAscDes = 3;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      });
                    }





                  }
                },
                itemBuilder: (BuildContext bc) {
                  return const [
                    PopupMenuItem(
                      value: 0,
                      child: ListTile(

                        title: Text("الاولوية-مستعجل"),
                      ),
                    ),

                    PopupMenuItem(
                      value: 1,

                      child: ListTile(

                        title: Text("الاولوية-عادي"),
                      ),

                    ),
                    PopupMenuItem(

                      value: 3,
                      child: Text("من الاحدث الى الاقدم"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("من الاقدم الى الاحدث"),
                    ),
                  ];

                },
              ),

              // PopUpMen(
              //
              //     menuList: const [
              //
              //       PopupMenuItem(
              //         value: 0,
              //         child: ListTile(
              //
              //           title: Text("الاولوية-مستعجل"),
              //         ),
              //       ),
              //       PopupMenuItem(
              //         value: 1,
              //         child: ListTile(
              //
              //           title: Text("الاولوية-متوسط"),
              //         ),
              //       ),
              //
              //       PopupMenuItem(
              //         value: 2,
              //
              //         child: ListTile(
              //
              //           title: Text("الاولوية-عادي"),
              //         ),
              //
              //       ),
              //       PopupMenuItem(
              //
              //         value: 3,
              //         child: Text("من الاحدث الى الاقدم"),
              //       ),
              //       PopupMenuItem(
              //         value: 4,
              //         child: Text("من الاقدم الى الاحدث"),
              //       ),
              //     ],
              //     icon: Image.asset('assets/filter.png'),
              //
              // ),

              SizedBox(width: 15,),

              SizedBox(
                height: 35,
                width: 220,
                child: TextField(

                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    print( _searchcontroller.text);
                    String searchitem  = _searchcontroller.text;
                    memoDataSearch = [];

                    List<String> yeaItem = [];


                    for(var item in itemSeachList){
                      print(item);
                      if(item.contains(searchitem)){
                        print("hhh");
                        //  print(item);
                        yeaItem.add(item) ;

                      }
                    }
                    print("yeaItem.length");
                    print(yeaItem.length.toString());
                    print("memoData.length");
                    print(memoData.length.toString());
                    print("memoDataSearch.length");
                    print(memoDataSearch.length.toString());



                    for(var x in yeaItem){
                      for(var i in memoData){

                        if(i.orderNo.toString().contains(x.split("/")[0])
                            &&i.citizenName.toString().contains(x.split("/")[1])
                        ){

                          memoDataSearch.add(i);


                        }
                        // else if(i.citizenName.toString().contains(x.split("/")[1])){
                        //   print(i.citizenName.toString());
                        //   print(x.split("/")[1]);
                        //   memoDataSearch.add(i);
                        //
                        //
                        // }
                        //
                        // else if( i.orderDesc.toString().contains(x.split("/")[2])){
                        //   print(i.orderDesc.toString());
                        //   print(x.split("/")[2]);
                        //   memoDataSearch.add(i);
                        //
                        // }

                      }

                    }
                    print("memoDataSearch.length");
                    print(memoDataSearch.length.toString());


                    setState(() {

                      listAscDes = 5;
                      BlocProvider.of<MemoBloc>(
                          context).add(SendData(
                          contactId,1));
                    });


                  },
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (_newValue) {

                    setState(() {


                      _searchcontroller.value = TextEditingValue(
                        text: _newValue,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: _newValue.length),
                        ),
                      );

                    });

                  },
                  controller: _searchcontroller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),


                    suffixIcon:
                    _searchcontroller.text.length > 0 ?IconButton(
                      onPressed:(){
                        _searchcontroller.text = "";
                        listAscDes= 10;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                            contactId,1));
                      }


                      ,
                      icon: Icon(Icons.clear,color: Colors.grey,),
                    ):
                    IconButton(
                      onPressed: _searchcontroller.clear,
                      icon: Icon(Icons.clear,color: Colors.grey.shade200,),
                    ),

                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(width: 1, color: Colors.grey),


                    ),
                    prefixIcon: Icon(Icons.search),

                    hintText: '',
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15,),

          Flexible(
            child: RefreshIndicator(
              onRefresh: ()async {
                setState(() {
                  listAscDes = 10;
                  BlocProvider.of<MemoBloc>(
                      context).add(SendData(
                      contactId,1));
                });

              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                reverse: false,
                itemCount:returnData.length,
                itemBuilder: (BuildContext context, int indexs) {

                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => memoDetailsScreen(
                          returnData[indexs].orderNo.toString(), returnData[indexs].citizenName.toString(), returnData[indexs].orderDesc.toString(),
                          returnData[indexs].recievingDate.toString(),  returnData[indexs].recieverContactPersonId.toString()
                          ,returnData[indexs].recieverContactPersonId.toString(),returnData[indexs].wantedFromReciever.toString()
                          ,returnData[indexs].contactPersonName.toString(),
                           returnData[indexs].recieverContactPersonId.toString()
                      )));
                    },
                    child: Container(
                      color: Colors.white,
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          //1st row

                          //2d row

                          Align(

                            child:
                            returnData[indexs].order_Priority == 1 ?
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
                                returnData[indexs].orderNo.toString(),
                                style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: "Al-Jazeera-Arabic-Regular"),
                              ),
                            ) :
                            returnData[indexs].order_Priority == 0? Container(

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
                                color: CustomColors.colorpriority_2,
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
                                returnData[indexs].orderNo.toString(),
                                style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: "Al-Jazeera-Arabic-Regular"),
                              ),
                            ) :
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
                                color: CustomColors.colorpriority_3,
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
                                returnData[indexs].orderNo.toString(),
                                style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: "Al-Jazeera-Arabic-Regular"),
                              ),
                            ),
                            alignment: Alignment.topRight,
                          ),




                          SizedBox(height: 8), //1st row

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
                                returnData[indexs].citizenName.toString(),
                                softWrap: false),
                          ),

                          SizedBox(height: 8), //1st row

                          //2d row
                          Container (
                            width: MediaQuery.of(context).size.width*0.9,
                            padding: EdgeInsets.all(4),
                            child: Text(textScaleFactor: textScaleFactor,

                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Al-Jazeera-Arabic-Regular"),
                                returnData[indexs].orderDesc.toString(),
                                softWrap: false),
                          ),
                          SizedBox(height: 8),


                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(alignment:
                            Alignment.bottomLeft,
                              child: InkWell(

                                  child: Text(textScaleFactor: textScaleFactor,
                                    returnData[indexs].recievingDate.toString().split("T").first,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Al-Jazeera-Arabic-Regular",
                                    ),
                                  ),
                                  onTap: (){


                                  }
                              ),),
                          )

                        ],

                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const  Divider(

                  height: 1,
                  thickness: 0.5,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],

      );
  }

  buildmainlayout(){
    return Center(
      child:
      Text("لا تتوفر بيانات",style: TextStyle(
          fontSize: 16,
          fontFamily: "Al-Jazeera-Arabic-Bold")),
    );
  }

  Widget CustomListTile(String text, String icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Container(

          child: InkWell(
              splashColor: Colors.grey,
              onTap: () async {
                CustomColors.index = 1;
                Navigator.pop(context);

                if (text == "البريد الصادر") {

                  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<MemoBloc>.value(
                          value: _sentMemoBloc,
                          child:  SentPage(this.contactId),
                        ),

                      ));

                }
                else if (text == "مذكرة جديدة") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddmemoScreen();
                  }));

                }
                else if (text == "الارشيف"){

                  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<MemoBloc>.value(
                          value: _sentMemoBloc,
                          child:  DraftPage(this.contactId),
                        ),

                      ));

                }else{

                }





              },
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Container(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(text,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xFFF1F1F1),
                                    fontFamily: "Al-Jazeera-Arabic-Bold")),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            icon == "sent"?    Image.asset('assets/sent.png'):
                            icon =="new"? Image.asset('assets/new.png'):
                            Image.asset('assets/draft.png')
                          ],
                        ),
                      ],
                    )),
              )),
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

  showMemoDialog(BuildContext context, String title, String msg) {

    // set up the button


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title,style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontFamily: "Al-Jazeera-Arabic-Regular"),textAlign: TextAlign.center,),
      content: Text(msg,style: TextStyle(
          fontSize: 15.0,
          color: Colors.black,
          fontFamily: "Al-Jazeera-Arabic-bold"),textAlign: TextAlign.center),

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
class PopUpMen extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const PopUpMen({Key? key, required this.menuList, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      itemBuilder: ((context) => menuList),
      icon: icon,
    );
  }
}