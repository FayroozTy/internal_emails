

import 'dart:async';
import 'dart:convert';

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Inbox/Model/Memo.dart';
import '../../Inbox/bloc/Memo/Memo_bloc.dart';
import '../../Inbox/bloc/Memo/Memo_event.dart';
import '../../Inbox/bloc/Memo/Memo_state.dart';
import '../../Inbox/ui/InboxScreen.dart';
import '../../MemoDetails/ui/memoDetailsScreen.dart';
import '../../Util/Constant.dart';




class DraftPage extends StatefulWidget {

  static String email = "";
  final int contactId;

  DraftPage(this.contactId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DraftScreen(this.contactId);
  }
}


class _DraftScreen extends State<DraftPage> {

  final int contactId;

  List<Memo> memoData = [];
  List<Memo> memoDataSearch = [];
  List<String> itemSeachList = [];
  List<Memo> itemDateAscList = [];
  List<String> itemDatedecsList = [];

  List<Memo> itemPriorityList_1= [];
  List<Memo> itemPriorityList_2= [];

  int  listAscDes= 10;
  var _searchcontroller = TextEditingController();
  _DraftScreen(this.contactId);

  @override
  void initState() {

    super.initState();
    BlocProvider.of<MemoBloc>(
        context).add(SendData(
       contactId,3));
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
                "الارشيف",
                style:  Theme.of(context).textTheme.barTextStyles,
              ),
            )),

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
               contactId,3));},

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

                print("ff");
                print(listAscDes);

                if(listAscDes == 0){
                  return  buildReturnlayout( itemPriorityList_1);

                  return buildReturnlayout(  itemDateAscList.reversed.toList());
                }
                else if (listAscDes == 5){
                  memoDataSearch.sort((a, b) => a.recievingDate!.compareTo(b.recievingDate!));

                  return   buildReturnlayout(memoDataSearch);
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
                  return buildReturnlayout(  itemDateAscList.reversed.toList());
                }





                // return buildReturnlayout( responseobj.reversed.toList());
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
                           contactId,3));
                      });
                    }else{

                      setState(() {
                        listAscDes = 0;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                           contactId,3));
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
                           contactId,3));
                      });
                    }else{

                      setState(() {
                        listAscDes = 1;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                           contactId,3));
                      });
                    }






                  }

                  else if (value == 2){

                    if(listAscDes == 5){
                      setState(() {
                        listAscDes = 25;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                           contactId,3));
                      });
                    }else{
                      setState(() {
                        listAscDes = 2;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                           contactId,3));
                      });
                    }





                  }

                  else if (value == 3){

                    if(listAscDes == 5){
                      setState(() {
                        listAscDes = 35;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                           contactId,3));
                      });
                    }else{
                      setState(() {
                        listAscDes = 3;
                        BlocProvider.of<MemoBloc>(
                            context).add(SendData(
                           contactId,3));
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
                         contactId,3));
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
                     contactId,3));
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
                          returnData[indexs].recievingDate.toString(),  returnData[indexs].recieverContactPersonId.toString(),returnData[indexs].recieverContactPersonId.toString()
                          ,returnData[indexs].wantedFromReciever.toString()
                          ,returnData[indexs].contactPersonName.toString()
                          ,  returnData[indexs].recieverContactPersonId.toString()
                      )));
                    },
                    child: Container(
                      color: indexs == 1 || indexs == 3 ?Colors.white:Color(0xFFF6F6F6),
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
                            icon == "Draft"?    Image.asset('assets/Draft.png'):
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

}
