import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Util/Constant.dart';






class MemoRepository {

  final String _Url =  BaseURL_Login + "api/Memos";


  Future<http.Response>  getList(int contact_Person_ID,int folderTypeId)async {



    return http.post(Uri.parse(_Url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(<String, dynamic>{
      "memoId": 0,
      "memoNo": 0,
      "contactPersonFolderId": 0,
      "folderTypeId": folderTypeId, //InBox
      "contact_Person_ID": contact_Person_ID //Contact_ID
    }),);




  }
}