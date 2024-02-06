import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'network_helper.dart';

enum RequestType { get, put, post }

class NetworkService{
  const NetworkService._();



  static Map<String, String> _getHeaders( String token) => {


    'Content-Type': 'application/json',

   "Authorization": "bearer " + token,


  };

  static Map<String, String> _getHeaderswithout() => {


    'Content-Type': 'application/json',




  };




  static Future<http.Response>? _createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }){
    if(requestType == RequestType.get){
      return http.get(uri, headers: headers);
    }
    return null;
  }

  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? queryParam,
  }) async {
    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token") ;
      print("token: $token");
      final _header;
      if(token == null){
         _header = _getHeaderswithout();
      }else{
         _header = _getHeaders(token);
      }

      final _url = NetworkHelper.concatUrlQP(url, queryParam);

      final response = await _createRequest(
          requestType: requestType,
          uri: Uri.parse(_url),
          headers: _header,
          body: body
      );

      return response;
    } catch (e){
      print('Error - $e');
      return null;
    }
  }
}