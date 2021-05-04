import 'package:cloud_firestore/cloud_firestore.dart';

class ChatData {
  String chatId, senderName, senderProfileUrl, senderUId, receiverName, receiverProfileUrl, receiverUId, date, time, message;

  ChatData(
      this.chatId,
      this.senderName,
      this.senderProfileUrl,
      this.senderUId,
      this.receiverName,
      this.receiverProfileUrl,
      this.receiverUId,
      this.date,
      this.time,
      this.message );

}


class LiveChatData {

  final String message;
  final String time;
  final String date;
  final String senderUId;
  final String receiverUId;

  final DocumentReference reference;

  LiveChatData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['time'] != null),
        assert(map['date'] != null),
        assert(map['senderId'] != null),
        assert(map['receiverId'] != null),

        message = map['message'],
        time = map['time'],
        date = map['date'],
        senderUId = map['senderId'],
        receiverUId = map['receiverId'];


  LiveChatData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);


}


class UserDataModel{

  final String userId;
  final String userName;
  final String userProfileImageUrl;

  final DocumentReference reference;

  UserDataModel.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map['UserId'] != null),
      assert(map['Name'] != null),

      userId = map['UserId'],
      userName = map['Name'],
      userProfileImageUrl = map['profileImage'];

  UserDataModel.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

}