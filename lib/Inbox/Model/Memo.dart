// To parse this JSON data, do
//
//     final memo = memoFromJson(jsonString);

import 'dart:convert';

List<Memo> memoFromJson(String str) => List<Memo>.from(json.decode(str).map((x) => Memo.fromJson(x)));

String memoToJson(List<Memo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Memo {
  int? orderTransId;
  int? orderId;
  int? orderNo;
  int? orderOwnerId;
  String? citizenName;
  int? orderTypeId;
  int? orderTypeNo;
  String? orderTypeDesc;
  int? orderStatusId;
  OrderStatusDesc? orderStatusDesc;
  int? contactPersonFolderId;
  ContactPersonFolderDesc? contactPersonFolderDesc;
  int? folderTypeId;
  int? senderContactPersonId;
  String? contactPersonName;
  String? recievingDate;
  String? wantedFromReciever;
  String? jobDesc;
  int? readingStatusId;
  String? readingStatusDate;
  String? departmentName;
  int? recieverContactPersonId;
  int? orderTypeCatId;
  String? orderDesc;
  int? order_Priority;
  String? order_Priority_Desc;

  Memo({
     this.orderTransId,
     this.orderId,
     this.orderNo,
     this.orderOwnerId,
     this.citizenName,
     this.orderTypeId,
     this.orderTypeNo,
     this.orderTypeDesc,
     this.orderStatusId,
     this.orderStatusDesc,
     this.contactPersonFolderId,
     this.contactPersonFolderDesc,
     this.folderTypeId,
     this.senderContactPersonId,
     this.contactPersonName,
     this.recievingDate,
     this.wantedFromReciever,
     this.jobDesc,
     this.readingStatusId,
     this.readingStatusDate,
     this.departmentName,
     this.recieverContactPersonId,
     this.orderTypeCatId,
     this.orderDesc,
    this.order_Priority,
    this.order_Priority_Desc
  });

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
    orderTransId: json["order_Trans_ID"],
    orderId: json["order_ID"],
    orderNo: json["order_No"],
    orderOwnerId: json["order_Owner_ID"],
    citizenName: json["citizen_Name"],
    orderTypeId: json["order_Type_ID"],
    orderTypeNo: json["order_Type_No"],
    orderTypeDesc: json["order_Type_Desc"],
    orderStatusId: json["order_Status_ID"],
    orderStatusDesc: orderStatusDescValues.map[json["order_Status_Desc"]],
    contactPersonFolderId: json["contact_Person_Folder_ID"],
    contactPersonFolderDesc: contactPersonFolderDescValues.map[json["contact_Person_Folder_Desc"]],
    folderTypeId: json["folder_Type_ID"],
    senderContactPersonId: json["sender_Contact_Person_ID"],
    contactPersonName: json["contact_Person_Name"],
    recievingDate: (json["recieving_Date"]),
    wantedFromReciever: json["wanted_From_Reciever"],
    jobDesc: json["job_Desc"],
    readingStatusId: json["reading_Status_ID"],
    readingStatusDate: (json["reading_Status_Date"]),
    departmentName: json["department_Name"],
    recieverContactPersonId: json["reciever_Contact_Person_ID"],
    orderTypeCatId: json["order_Type_Cat_ID"],
    orderDesc: json["order_Desc"],
    order_Priority: json["order_Priority"],
    order_Priority_Desc: json["order_Priority_Desc"],
  );

  Map<String, dynamic> toJson() => {
    "order_Trans_ID": orderTransId,
    "order_ID": orderId,
    "order_No": orderNo,
    "order_Owner_ID": orderOwnerId,
    "citizen_Name": citizenName,
    "order_Type_ID": orderTypeId,
    "order_Type_No": orderTypeNo,
    "order_Type_Desc": orderTypeDesc,
    "order_Status_ID": orderStatusId,
    "order_Status_Desc": orderStatusDescValues.reverse[orderStatusDesc],
    "contact_Person_Folder_ID": contactPersonFolderId,
    "contact_Person_Folder_Desc": contactPersonFolderDescValues.reverse[contactPersonFolderDesc],
    "folder_Type_ID": folderTypeId,
    "sender_Contact_Person_ID": senderContactPersonId,
    "contact_Person_Name": contactPersonName,
    "recieving_Date": recievingDate,
    "wanted_From_Reciever": wantedFromReciever,
    "job_Desc": jobDesc,
    "reading_Status_ID": readingStatusId,
    "reading_Status_Date": readingStatusDate,
    "department_Name": departmentName,
    "reciever_Contact_Person_ID": recieverContactPersonId,
    "order_Type_Cat_ID": orderTypeCatId,
    "order_Desc": orderDesc,
    "order_Priority": order_Priority,
    "order_Priority_Desc": order_Priority_Desc,
  };
}

enum ContactPersonFolderDesc {
  EMPTY
}

final contactPersonFolderDescValues = EnumValues({
  "صندوق الوارد": ContactPersonFolderDesc.EMPTY
});

enum OrderStatusDesc {
  EMPTY
}

final orderStatusDescValues = EnumValues({
  "قيد التنفيذ": OrderStatusDesc.EMPTY
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
