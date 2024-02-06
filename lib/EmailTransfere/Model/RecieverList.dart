// To parse this JSON data, do
//
//     final recieverList = recieverListFromJson(jsonString);

import 'dart:convert';

List<RecieverList> recieverListFromJson(String str) => List<RecieverList>.from(json.decode(str).map((x) => RecieverList.fromJson(x)));

String recieverListToJson(List<RecieverList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecieverList {
  int? toWhomCanUserTransferId;
  int? contactPersonId;
  String? contactPersonName;
  int? toWhomCanTransfer;
  int? orderTypeCatId;
  String? userName;

  RecieverList({
     this.toWhomCanUserTransferId,
     this.contactPersonId,
     this.contactPersonName,
     this.toWhomCanTransfer,
     this.orderTypeCatId,
     this.userName,
  });

  factory RecieverList.fromJson(Map<String, dynamic> json) => RecieverList(
    toWhomCanUserTransferId: json["to_Whom_Can_User_Transfer_ID"],
    contactPersonId: json["contact_Person_ID"],
    contactPersonName: json["contact_Person_Name"],
    toWhomCanTransfer: json["to_Whom_Can_Transfer"],
    orderTypeCatId: json["order_Type_Cat_ID"],
    userName: json["user_Name"],
  );

  Map<String, dynamic> toJson() => {
    "to_Whom_Can_User_Transfer_ID": toWhomCanUserTransferId,
    "contact_Person_ID": contactPersonId,
    "contact_Person_Name": contactPersonNameValues.reverse[contactPersonName],
    "to_Whom_Can_Transfer": toWhomCanTransfer,
    "order_Type_Cat_ID": orderTypeCatId,
    "user_Name": userName,
  };
}

enum ContactPersonName {
  EMPTY
}

final contactPersonNameValues = EnumValues({
  "مدير قسم البرمجة": ContactPersonName.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
