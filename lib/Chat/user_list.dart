import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findyourplumber/Chat/chat_screen.dart';
import 'package:findyourplumber/Chat/data_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  TextEditingController _searchController = TextEditingController();
  SharedPreferences prefs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar()),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _buildBody(context),
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("User").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(color: Colors.white);
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot documentSnapshot) {
    final record = UserDataModel.fromSnapshot(documentSnapshot);

    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.brown[200],
                radius: 35.0,
                child: record.userProfileImageUrl!=null ?
                Image.network(record.userProfileImageUrl, fit: BoxFit.fill,)
                    : Image.asset("assets/images/profile_image.png")
              ),
              SizedBox(width: 12.0,),
              Text(record.userName, style: TextStyle(fontSize: 18.0),)
            ]),
          FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 50.0,
            child: null,
            onPressed: () async {
              prefs = await SharedPreferences.getInstance();
              String myId = prefs.getString("currentUser");
              String senderName = prefs.getString("userName");
              String chatId = myId + "" + record.userId;

              if (myId == record.userId){
                //  you cannot send message to yourself
              } else{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(
                    chatId, myId, senderName, "", record.userName,
                    record.userProfileImageUrl!=null ? record.userProfileImageUrl : "", record.userId)));
              }
            },
          ),
        ],
      ),
    );

  }


  Widget _searchFunction(){
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 15.0),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Find user by name',
          hintStyle: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400, fontSize: 17),
          prefixIcon: Icon(Icons.search_rounded),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[300])
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.lightBlue[700], width: 1.5)
          ),
        ),
        onChanged: (value){ },

      ),

    );
  }


}
