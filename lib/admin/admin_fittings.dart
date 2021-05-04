import 'package:findyourplumber/admin/form_addEdit.dart';
import 'package:findyourplumber/admin/form_delete.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AdminManageFitting extends StatefulWidget {
  @override
  _AdminManageFittingState createState() => _AdminManageFittingState();
}

class _AdminManageFittingState extends State<AdminManageFitting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        title: Text('Fittings',
            style: TextStyle(
              fontSize: 21,
            )),
      ),


      //FIREBASE INSTANCE
      body: StreamBuilder(
        stream: Firestore.instance.collection('Fitting').snapshots(),
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

                return Container(
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
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['Fittings'],
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
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
                          deleteType: DeleteType.fitting,
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
                          editType: EditType.fitting,
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
                          editType: EditType.fitting,
                          operationType: OperationType.add,
                        )));
              }),



        ],
      ),
    );
  }
}
