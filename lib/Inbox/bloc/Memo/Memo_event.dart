
abstract class MemoEvent {}

class SendData extends MemoEvent {
  final int contact_Person_ID;

  final int folderTypeId;



  SendData(this.contact_Person_ID,this.folderTypeId);
}