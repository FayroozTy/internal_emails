import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final textScaleFactor =  1.0;
 int groupTransfere =  1;
 //applicationuser
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CustomColors {
  static const Color colorPrimary = Color(0xFF1C2847);
  static const Color colorPrimaryDark = Color(0xFF354366);
  static const Color colorAccent = Color(0xFF0da43a);
  static const Color roundedButtonText = Color(0xFFE6ECEC);
  static const Color colorWhite = Color(0xFFffff);
  static const Color colorgray = Color(0xFF5c5c5c);
  static const Color colorpriority_1 = Color(0xFF923731);
  static const Color colorpriority_2 = Color(0xFF4A587A);
  static const Color colorpriority_3= Color(0xFF295F56);

  static var index = 0;
}
//String BaseURL_Login ="http://192.168.0.128:7575/";
String BaseURL_Login ="http://83.244.112.170:7575/";

String BaseURL_forgetpassword = "http://83.244.112.170:5135";

extension CustomTextStyles  on TextTheme {
  TextStyle get barTextStyles {
    return TextStyle(
        fontSize: 17.0,
        color: Colors.white,
        fontFamily: "Al-Jazeera-Arabic-Regular");
  }
  TextStyle get TextStyles1 {
    return TextStyle(
        fontSize: 14.0,
        color: CustomColors.colorPrimary,
        fontFamily: "Al-Jazeera-Arabic-Regular");
  }

  TextStyle get TextStyles2 {
    return TextStyle(
        fontSize: 14.0,
        color: Color(0xFF686868),
        fontFamily: "Al-Jazeera-Arabic-Regular");
  }
}



///

//back splash screen
//seen ()
//filter
//serach to home
// drawer name
//

///