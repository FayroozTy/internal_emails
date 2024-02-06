// To parse this JSON data, do
//
//     final contactLogins = contactLoginsFromJson(jsonString);

import 'dart:convert';

List<ContactLogins> contactLoginsFromJson(String str) => List<ContactLogins>.from(json.decode(str).map((x) => ContactLogins.fromJson(x)));

String contactLoginsToJson(List<ContactLogins> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContactLogins {
  int? contactLoginId;
  String? loginName;
  int? contactLoginTypId;
  int? statusId;
  dynamic statusDate;
  dynamic notes;
  dynamic userName;
  String? timeStamp;
  int? contactId;
  bool? loginIsContctPrsn;
  String? contactPersonName;

  ContactLogins({
     this.contactLoginId,
     this.loginName,
     this.contactLoginTypId,
     this.statusId,
     this.statusDate,
     this.notes,
     this.userName,
     this.timeStamp,
     this.contactId,
     this.loginIsContctPrsn,
     this.contactPersonName,
  });

  factory ContactLogins.fromJson(Map<String, dynamic> json) => ContactLogins(
    contactLoginId: json["contact_Login_ID"],
    loginName: json["login_Name"],
    contactLoginTypId: json["contact_Login_Typ_ID"],
    statusId: json["status_ID"],
    statusDate: json["status_Date"],
    notes: json["notes"],
    userName: json["user_Name"],
    timeStamp: (json["time_Stamp"]),
    contactId: json["contact_ID"],
    loginIsContctPrsn: json["login_Is_Contct_Prsn"],
    contactPersonName: json["contact_Person_Name"],
  );

  Map<String, dynamic> toJson() => {
    "contact_Login_ID": contactLoginId,
    "login_Name": loginName,
    "contact_Login_Typ_ID": contactLoginTypId,
    "status_ID": statusId,
    "status_Date": statusDate,
    "notes": notes,
    "user_Name": userName,
    "time_Stamp": timeStamp,
    "contact_ID": contactId,
    "login_Is_Contct_Prsn": loginIsContctPrsn,
    "contact_Person_Name": contactPersonName,
  };
}
