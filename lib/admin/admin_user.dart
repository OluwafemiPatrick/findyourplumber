import 'package:findyourplumber/admin/form_delete.dart';
import 'package:findyourplumber/admin/user_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class AdminManageUser extends StatefulWidget {
  @override
  _AdminManageUserState createState() => _AdminManageUserState();
}

class _AdminManageUserState extends State<AdminManageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text('Users', style: TextStyle(fontSize: 21,)),
        centerTitle: true,
      ),

      //FIREBASE INSTANCE
      body: StreamBuilder(
        stream: Firestore.instance.collection('User').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ));

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = snapshot.data.documents[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(
                          userAddress: user.data['Address'],
                          userEmail: user.data['Email'],
                          userName: user.data['Name'],
                          userPhone: user.data['Phone'],
                          userImage: user.data['ProfileImage'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 25, top: 20, right: 25),
                    padding: EdgeInsets.only(left: 25, top: 25),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                    ),
                    child: Text(
                      user['Name'],
                      style:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                    ),

                  ),
                );
              });
        },
      ),

      //FLOATING BUTTONS
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blueGrey[900],
        children: [

          SpeedDialChild(
              child: Icon(Icons.delete_rounded),
              backgroundColor: Colors.blueGrey[600],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteForm(
                          deleteType: DeleteType.user,
                        )));
              }),

        ],
      ),
    );
  }
}
