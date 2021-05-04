import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findyourplumber/edit_profile.dart';
import 'package:findyourplumber/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: IconButton(
                icon: Icon(Icons.exit_to_app_rounded, size: 30, color: Colors.lightBlue[800],),
              onPressed: () async {
                try {
                  AuthService auth = new AuthService();
                  await auth.signOut();
                  print('Sign out');
                } catch (e) {
                  print(e);
                }
              },

                ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  String image;

                  FirebaseStorage.instance
                      .ref()
                      .child("User")
                      .child(snapshot.data.uid)
                      .getDownloadURL()
                      .then((value) {
                    image = value;
                  });

                  return displayUserInformation(context, snapshot, image);
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot, String image) {
    final FirebaseUser user = snapshot.data;
    print(user);
    return Center(
      child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('User')
              .document(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map userData = snapshot.data.data;
              String userName =
                  userData['Name'] == null || userData['Name'] == ''
                      ? 'N'
                      : userData['Name'];

              String userEmail =
                  userData['Email'] == null || userData['Email'] == ''
                      ? ''
                      : userData['Email'];

              String userPhone =
                  userData['Phone'] == null || userData['Phone'] == ''
                      ? ''
                      : userData['Phone'];

              String userAddress =
                  userData['Address'] == null || userData['Address'] == ''
                      ? ''
                      : userData['Address'];

              String userImage = userData['profileImage'] == null ||
                      userData['profileImage'] == ''
                  ? ''
                  : userData['profileImage'];
              return Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[

                    CircleAvatar(
                      backgroundImage: NetworkImage(userImage ??
                          'https://www.clipartkey.com/mpngs/m/152-1520367_user-profile-default-image-png-clipart-png-download.png'),
                      minRadius: 60,
                      maxRadius: 60,
                    ),


                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 15, top: 30),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Icon(Icons.person_rounded,
                                  color: Colors.grey[700]),
                              SizedBox(width: 25),
                              Text(userName ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 15, top: 8),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Icon(Icons.email_rounded,
                                  color: Colors.grey[700]),
                              SizedBox(
                                width: 25,
                              ),
                              Text(userEmail ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 15, top: 8),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey[700]),
                              SizedBox(
                                width: 25,
                              ),
                              Text(userPhone ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 15, top: 8),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: Colors.grey[700]),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                userAddress ?? '',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    //EDIT PROFILE
                    Container(
                      width: MediaQuery.of(context).size.height * 0.2,
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.lightBlue[800],
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(color: Colors.white, fontSize: 21),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    userId: user.uid,
                                    email: userEmail,
                                    userName: userName,
                                    phoneNumber: userPhone,
                                    address: userAddress,
                                    imageUrl: userImage,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),

                    SizedBox(height: 40,),



                  ],
                ),
              );
            } else {
              return Text("Loading...");
            }
          }),
    );
  }
}
