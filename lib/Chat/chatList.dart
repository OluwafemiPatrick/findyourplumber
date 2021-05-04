import 'dart:async';

import 'package:findyourplumber/Chat/chat_screen.dart';
import 'package:findyourplumber/Chat/data_model.dart';
import 'package:findyourplumber/Chat/user_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  List<ChatData> messageList = [];

  String _userName;
  int _loadTime = 0;
  bool _isQueryComplete = false;

  static const colorBlack = Colors.black;
  static const colorBrown = Colors.brown;
  static const colorBlue = Colors.blueAccent;


  @override
  Widget build(BuildContext context) {
    if(messageList.length<1 && _loadTime<2){
      _fetchChatsFromDB();
      _loadTime++;
    }
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar()),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10.0, 4, 8.0, 5.0),
          child: _messages()
        ),

      floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Semantics(
          label: 'add new user',
          child: FloatingActionButton(
            backgroundColor: Colors.lightBlue[800],
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsersList()));
            },
            child: const Icon(Icons.add, size: 32,
            ),
          ),
        )
      ],
    ));

  }


  Widget _messages(){
    return _isQueryComplete ? RefreshIndicator(
      onRefresh: () async {
        setState(() => _isQueryComplete = false);
        _fetchChatsFromDB();
      },
      child: messageList.length>0 ? ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          itemCount: messageList.length,
          itemBuilder: (_, index){
            return _messageList(
              messageList[index].senderName,
              messageList[index].senderProfileUrl,
              messageList[index].senderUId,
              messageList[index].receiverName,
              messageList[index].receiverProfileUrl,
              messageList[index].receiverUId,
              messageList[index].message,
              messageList[index].date,
              messageList[index].time,
              messageList[index].chatId,
            );
          }
      ) :  Center(child: Text("You do not have any message", style: TextStyle(fontSize: 14.0),)
      ),
    ) : Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CircularProgressIndicator()),
    );

  }


  Widget _messageList(String senderName, senderProfileUrl, senderUId, receiverName, receiverProfileUrl, receiverUId, message, date, time, chatId){

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      child: Stack(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 48.0,
                    width: 50.0,
                    margin: EdgeInsets.only(right: 15.0),
                    decoration: BoxDecoration(
                        color: colorBlue,
                        borderRadius: new BorderRadius.all(Radius.circular(24.0))
                    ),
                    child: senderProfileUrl!="" ? Image.network(senderProfileUrl) : Image.asset("assets/images/profile_image.png")
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_userName==senderName ? receiverName : senderName, style: TextStyle(
                                      fontSize: 17.0, color: colorBlack),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(message,
                                    style: TextStyle(fontSize: 14.0, color: colorBlack),
                                    maxLines: 1,
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: 60.0,
                            height: 35.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 2.0,),
                                Text(time, style: TextStyle(fontSize: 12.0, color: colorBrown),),
                                SizedBox(height: 3.0,),
                                Text(date, style: TextStyle(fontSize: 11.0, color: colorBrown),)
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(thickness: 1.5)
                    ],
                  ),
                ),
              ]),
          FlatButton(
            height: 48.0,
            minWidth: MediaQuery.of(context).size.width,
            child: null,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(
                  chatId, senderUId, senderName, senderProfileUrl, receiverName, receiverProfileUrl, receiverUId)));
            }
          )
        ],
      ),
    );
  }


  Future _fetchChatsFromDB() async {

    FirebaseDatabase databaseReference = FirebaseDatabase.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Timer(
      Duration(seconds: 5), () {
      setState(() => _isQueryComplete = true);
    },
    );

    setState(() => _userName = prefs.getString("userName"));

    databaseReference.reference().child("chats").child(prefs.getString("currentUser"))
        .once().then((DataSnapshot dataSnapshot) {
      messageList.clear();
      setState(() => _isQueryComplete = true);
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys){
        ChatData data = new ChatData(
          values [key]["chatId"],
          values [key]["senderName"],
          values [key]["senderProfileUrl"],
          values [key]["senderUId"],
          values [key]["receiverName"],
          values [key]["receiverProfileUrl"],
          values [key]["receiverUId"],
          values [key]["date"],
          values [key]["time"],
          values [key]["message"],
        );
        messageList.add(data);
      }
    });
  }


}
