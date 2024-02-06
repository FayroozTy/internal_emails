import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_emails/Addmemo/ui/Addmemo.dart';
import 'package:internal_emails/Inbox/ui/InboxScreen.dart';
import 'package:internal_emails/Login/ui/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Inbox/bloc/Memo/Memo_bloc.dart';
import 'Inbox/repository/MemoServive.dart';
import 'Util/Constant.dart';

void main() { WidgetsFlutterBinding.ensureInitialized();
runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override


  Widget build(BuildContext context) {


    // This widget is the root of your application.

    return MaterialApp(
      navigatorKey:navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      //builder: (context, child) => SafeArea(child: BookingListScreen()),

      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) =>  SplashScreen(),
        '/loginPage()': (context) =>  loginPage(),
      //  '/InboxScreen()': (context) =>  InboxScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.

      },
      //home: Inform_List(),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final MemoBloc _tanzeemBloc = MemoBloc(MemoRepository());


  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {



    Timer(
        const Duration(seconds: 6),
            () async =>{
          movenext()
        }

    );

    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,


        body: Stack(
          children: <Widget>[

            Align(alignment: Alignment.topLeft,
                child: Image.asset('assets/splash_cur2.png',height: 150,)),

            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child:
                    Image.asset('assets/Nablus_Logo.png')
                ),

                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "بلدية نابلس",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontFamily: "Al-Jazeera-Arabic-Bold"),
                  ),
                ),
                SizedBox(height: 10,),

                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "المراسلات الداخلية",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Color(0xFF333333),
                        fontFamily: "Al-Jazeera-Arabic-Regular"),
                  ),
                ),

              ],
            ),

            Align(alignment: Alignment.bottomRight,
                child: Image.asset('assets/splash_cur1.png',height: 150,)),
          ],
        ));
  }

  movenext() async {
   // /InboxScreen()


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isLogin = prefs.getString("isLogin") ?? "false";

    print("islogin$isLogin");

 if (isLogin == "false"){
     navigatorKey.currentState?.pushNamed('/loginPage()');


    }else{
  int contactId= prefs.getInt("contactId") ?? 0;
  print("cc");
  print(contactId.toString());

  Navigator.push(context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<MemoBloc>.value(
          value: _tanzeemBloc,
          child:  InboxScreen(contactId),
        ),

      ));

    }




      // mainPage()

      // Navigator.push(context, new MaterialPageRoute(builder: (context) => InboxPage()));
    }
  }


  ///Receive message when app is in background solution for on message




