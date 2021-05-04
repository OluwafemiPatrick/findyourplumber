import 'package:findyourplumber/admin/form_delete.dart';
import 'package:findyourplumber/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'form_addEdit.dart';


class AdminManageService extends StatefulWidget {
  @override
  _AdminManageServiceState createState() => _AdminManageServiceState();
}

class _AdminManageServiceState extends State<AdminManageService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text('Services', style: TextStyle(fontSize: 21,)),
        centerTitle: true,
      ),

      //FIREBASE INSTANCE
      body: StreamBuilder(
        stream: Firestore.instance.collection('My Services').snapshots(),
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
                DocumentSnapshot service = snapshot.data.documents[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetails(
                          OpenFrom.admin,
                          description: service.data['Description'],
                          serviceImage: service.data['image'],
                          serviceName: service.data['Service'],
                          servicePrice: service.data['Estimated Price'],
                          maxPrice: service.data['Max Price'],
                          minPrice: service.data['Min Price'],
                          ratingNumber: service.data['Rating'],
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
                      service['Service'],
                      style:
                      TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
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

          //DELETE BUTTON
          SpeedDialChild(
              child: Icon(Icons.delete_rounded),
              backgroundColor: Colors.blueGrey[600],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteForm(
                          deleteType: DeleteType.services,
                        )));
              }),

          //ADD BUTTON
          SpeedDialChild(
              child: Icon(Icons.edit),
              backgroundColor: Colors.blueGrey[600],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditForm(
                          editType: EditType.services,
                          operationType: OperationType.edit,
                        )));
              }),

          //EDIT BUTTON
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey[600],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditForm(
                          editType: EditType.services,
                          operationType: OperationType.add,
                        )));
              }),
        ],
      ),
    );
  }
}
