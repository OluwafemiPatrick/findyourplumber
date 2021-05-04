import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findyourplumber/Chat/data_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider.dart';

class ChatScreen extends StatefulWidget {

  final String chatId, senderId, senderName, senderProfileUrl, receiverName, receiverProfileUrl, receiverId;

  ChatScreen(this.chatId, this.senderId, this.senderName, this.senderProfileUrl,
      this.receiverName, this.receiverProfileUrl, this.receiverId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String _chatId, _message, _time, _date, _senderId="", _senderName="", _senderProfileUrl="", _receiverId,
      _receiverName="", _receiverProfileUrl="";

  bool _isLoading = false;
  final _controller = ScrollController();

  static const colorWhite = Colors.white;
  static const colorBlue = Colors.blueAccent;
  static const colorBlack = Colors.black;
  static const colorGreen = Colors.green;

  @override
  void initState() {
    _retrieveDataFromPreviousPage();
    _scrollToBottom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            backgroundColor: colorBlue,
            iconTheme: IconThemeData(color: colorWhite, size: 10),
            centerTitle: true,
            title: Text(_receiverName, style: TextStyle(color: colorWhite),)
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
              children: [
                Image.asset("assets/images/chat_background.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,),
                Column(
                    children: [
                      Expanded(child: _buildBody(context)),
                      _bottomSection(),
                    ]),
              ]),
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(_chatId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(color: colorWhite);
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot documentSnapshot) {
    final record = LiveChatData.fromSnapshot(documentSnapshot);
    int data;

    if (_senderId == record.senderUId){
      data = 1;
    } else{
      data = 0;                                                                                                                                                                                                                                                                                                                                                                                          ;
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
          mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Bubble(
                radius: Radius.circular(15.0),
                color: data == 0 ? colorWhite : Colors.grey[400],
                elevation: 0.0,
                child: Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 4.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.message, style: TextStyle(fontSize: 16.0, color: colorBlack),),
                        SizedBox(height: 15.0,),
                        Row(
                          children: [
                            Text(record.date, style: TextStyle(fontSize: 12.0, color: colorBlack),),
                            SizedBox(width: 6.0,),
                            Text(record.time, style: TextStyle(fontSize: 12.0, color: colorBlack),),
                          ],
                        ),
                      ],
                    )
                )
            ),

          ]),
    );
  }


  Widget _bottomSection(){
    return _isLoading ? CircularProgressIndicator() : Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: new BoxDecoration(color: colorWhite,
                    borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  autofocus: false,
                  autocorrect: true,
                  decoration: InputDecoration(hintText: "Type a message"),
                  style: TextStyle(fontSize: 16.0, color: colorBlack),
                  onChanged: (value) => setState(() => _message = value),
                ),
              ),
            ),
            SizedBox(width: 6.0),
            Container(
              width: 46.0,
              decoration: new BoxDecoration(color: Colors.lightBlue[800],
                  borderRadius: new BorderRadius.all(Radius.circular(25.0))),
              child: FlatButton(
                child: Icon(Icons.send, color: colorWhite, size: 22.0,),
                onPressed: () {
                  if(_message!=null || _message.isNotEmpty){
                    _generateDateAndTime();
                  }
                },
              ),
            )
          ]),
    );
  }


  Future _sendMessageToFireStore (String date, time, message, senderId, receiverId) async {
    final savedRouteRef = Firestore.instance.collection(_chatId);
    setState(() => _isLoading = true);

    return await savedRouteRef.document(currentTimeInSeconds()).setData({
      'message': message,
      'time': time,
      'date': date,
      'senderId': senderId,
      'receiverId' : receiverId,
    }).then((value) {
      setState(() {
        _isLoading = false;
        _message = "";
      });
    });
  }


  Future _sendMessageToSenderAndReceiverDB(String senderName, senderProfileUrl, senderUId, receiverName, receiverProfileUrl,
      receiverUId, message, date, time, chatId) async {

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("chats");

    databaseReference.child(senderUId).child(chatId).set({
      "senderName" : senderName,
      "senderProfileUrl" : senderProfileUrl,
      "senderUId" : senderUId,
      "receiverName" : receiverName,
      "receiverProfileUrl" : receiverProfileUrl,
      "receiverUId" : receiverUId,
      "chatId" : chatId,
      "message" : message,
      "date" : date,
      "time" : time,
    });

    databaseReference.child(receiverUId).child(chatId).set({
      "senderName" : senderName,
      "senderProfileUrl" : senderProfileUrl,
      "senderUId" : senderUId,
      "receiverName" : receiverName,
      "receiverProfileUrl" : receiverProfileUrl,
      "receiverUId" : receiverUId,
      "chatId" : chatId,
      "message" : message,
      "date" : date,
      "time" : time,
    });

  }



  _generateDateAndTime() async {
    DateTime now = DateTime.now();
    setState(() {
      _date = DateFormat('EEE d MMM').format(now);
      _time = DateFormat('kk:mm').format(now);
    });

    _sendMessageToSenderAndReceiverDB(_senderName, _senderProfileUrl,
        _senderId, _receiverName, _receiverProfileUrl, _receiverId, _message, _date, _time, _chatId);
    _sendMessageToFireStore(_date, _time, _message, _senderId, _receiverId);

  }

  static String currentTimeInSeconds() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    return (ms / 1000).round().toString();
  }

  _scrollToBottom(){
    Timer(
      Duration(seconds: 1),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
  }

  _retrieveDataFromPreviousPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("currentUser");
    String chatId = widget.chatId;

    if (userId[5] == chatId[5]){
      setState(() {
        _chatId = widget.chatId;
        _senderId = widget.senderId;
        _senderName = widget.senderName;
        _senderProfileUrl = widget.senderProfileUrl;
        _receiverName = widget.receiverName;
        _receiverProfileUrl = widget.receiverProfileUrl;
        _receiverId = widget.receiverId;
      });
    } else{
      setState(() {
        _chatId = widget.chatId;
        _senderId = widget.receiverId;
        _senderName = widget.receiverName;
        _senderProfileUrl = widget.receiverProfileUrl;
        _receiverName = widget.senderName;
        _receiverProfileUrl = widget.senderProfileUrl;
        _receiverId = widget.senderId;
      });
    }
  }



}
