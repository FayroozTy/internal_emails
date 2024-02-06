// To parse this JSON data, do
//
//     final orderTrans = orderTransFromJson(jsonString);

import 'dart:convert';

List<OrderTrans> orderTransFromJson(String str) => List<OrderTrans>.from(json.decode(str).map((x) => OrderTrans.fromJson(x)));

String orderTransToJson(List<OrderTrans> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderTrans {
  int orderTransId;
  int orderId;
  int senderContactPersonId;
  String senderContactPersonName;
  int recieverContactPersonId;
  String recieverContactPersonName;
  String? sendingDate;
  String recievingDate;
  String? wantedFromReciever;

  OrderTrans({
    required this.orderTransId,
    required this.orderId,
    required this.senderContactPersonId,
    required this.senderContactPersonName,
    required this.recieverContactPersonId,
    required this.recieverContactPersonName,
    required this.sendingDate,
    required this.recievingDate,
    required this.wantedFromReciever,
  });

  factory OrderTrans.fromJson(Map<String, dynamic> json) => OrderTrans(
    orderTransId: json["order_Trans_ID"],
    orderId: json["order_ID"],
    senderContactPersonId: json["sender_Contact_Person_Id"],
    senderContactPersonName: json["sender_Contact_Person_Name"],
    recieverContactPersonId: json["reciever_Contact_Person_Id"],
    recieverContactPersonName: json["reciever_Contact_Person_Name"],
    sendingDate: json["sending_Date"],
    recievingDate: (json["recieving_Date"]),
    wantedFromReciever: json["wanted_From_Reciever"],
  );

  Map<String, dynamic> toJson() => {
    "order_Trans_ID": orderTransId,
    "order_ID": orderId,
    "sender_Contact_Person_Id": senderContactPersonId,
    "sender_Contact_Person_Name": senderContactPersonName,
    "reciever_Contact_Person_Id": recieverContactPersonId,
    "reciever_Contact_Person_Name": recieverContactPersonName,
    "sending_Date": sendingDate,
    "recieving_Date": recievingDate,
    "wanted_From_Reciever": wantedFromReciever,
  };
}
