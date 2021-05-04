import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String email;
  final String userId;
  final String address;
  final String imageUrl;
  EditProfile(
      {Key key,
      this.userId,
      this.userName,
      this.phoneNumber,
      this.email,
      this.address,
      this.imageUrl})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String profileImage = "";

  @override
  void initState() {
    _nameController.text = widget.userName;
    _emailController.text = widget.email;
    _phoneController.text = widget.phoneNumber;
    _addressController.text = widget.address;
    profileImage = widget.imageUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _formKey,
        backgroundColor: Colors.white,

        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 21,
              ),
            ),
          ),
          backgroundColor: Colors.lightBlue[800],
        ),

        //PAGE UI
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profileImage ??
                            'https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8M3x8fGVufDB8fHx8&w=1000&q=80'),
                        maxRadius: 60,
                        minRadius: 60,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          PickedFile selectedImage =
                              await ImagePicker.platform.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 100,
                          );
                          StorageTaskSnapshot task =
                              await FirebaseStorage.instance
                                  .ref()
                                  .child("User")
                                  .child(widget.userId)
                                  .putFile(
                                    File(selectedImage.path),
                                  )
                                  .onComplete;

                          String imageUrl = await FirebaseStorage.instance
                              .ref()
                              .child("User")
                              .child(widget.userId)
                              .getDownloadURL();

                          Firestore.instance
                              .collection("User")
                              .document(widget.userId)
                              .updateData({"profileImage": imageUrl});
                          setState(() {
                            profileImage = imageUrl;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Text(
                              'Change Profile Image',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.edit, color: Colors.lightBlue[800],),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.lightBlue[900],
                            width: 1.5,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.lightBlue[900],
                            width: 1.5,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.lightBlue[900],
                            width: 1.5,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.lightBlue[900],
                            width: 1.5,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Semantics(
              child: FloatingActionButton.extended(
                backgroundColor: Colors.lightBlue[700],
                onPressed: () async {
                  String name = "";
                  String email = "";
                  String phone = "";
                  String address = "";
                  if (_nameController.text != null &&
                      _nameController.text != "") {
                    name = _nameController.text;
                  }
                  if (_emailController.text != null &&
                      _emailController.text != "") {
                    email = _emailController.text;
                  }
                  if (_phoneController.text != null &&
                      _phoneController.text != "") {
                    phone = _phoneController.text;
                  }
                  if (_addressController.text != null &&
                      _addressController.text != "") {
                    address = _addressController.text;
                  }

                  Map<String, dynamic> profileData = {
                    "Name": name,
                    "Email": email,
                    "Phone": phone,
                    "Address": address,
                  };

                  db.collection("User")
                      .document(widget.userId)
                      .updateData(profileData);

                  // Provider.of(context).auth.getCurrentUser().then((value) {
                  //   FirebaseUser user = value;
                  //   user.updateEmail(email);
                  //   UserUpdateInfo userInfo = UserUpdateInfo();
                  //   userInfo.displayName = name;
                  //   user.updateProfile(userInfo).then((value) => user.reload());
                  // });

                  Navigator.pop(context);
                },
                icon: Icon(Icons.check),
                label: Text(
                  'Update',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            )
          ],
        ));
  }
}
