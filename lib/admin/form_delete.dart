
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum DeleteType {
  user,
  fitting,
  booking,
  services,
}

class DeleteForm extends StatefulWidget {
  final DeleteType deleteType;

  const DeleteForm({Key key, @required this.deleteType})
      : assert(deleteType != null);
  @override
  _DeleteFormState createState() => _DeleteFormState();
}

class _DeleteFormState extends State<DeleteForm> {
  String service;
  String selectedDataName;
  String selectedDataId;
  String selectedBookingUserId;
  final _formKey = GlobalKey<FormState>();
  final serviceField = TextEditingController();

  getService(service) {
    this.service = service;
  }

  @override
  void initState() {
    super.initState();
    fetchDropDownDataToDelete();
  }

  void clearText() {
    serviceField.clear();
    selectedDataName = null;
    selectedDataId = null;
    selectedBookingUserId = null;
  }

  //DELETE BUTTON
  Future<void> deleteData() async {
    DocumentReference documentReference;
    if (widget.deleteType == DeleteType.services) {
      documentReference =
          Firestore.instance.collection('My Services').document(selectedDataId);
    } else if (widget.deleteType == DeleteType.fitting) {
      documentReference =
          Firestore.instance.collection('Fitting').document(selectedDataId);
    } else if (widget.deleteType == DeleteType.booking) {
      documentReference = Firestore.instance
          .collection('User')
          .document(selectedBookingUserId)
          .collection("Booking")
          .document(selectedDataId);
    } else if (widget.deleteType == DeleteType.user) {
      print('1');

      await Firestore.instance
          .collection('User')
          .document(selectedDataId)
          .collection('Booking')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });

      documentReference =
          Firestore.instance.collection('User').document(selectedDataId);
    }
    print('5');

    await documentReference.delete().whenComplete(() async {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(
                  'Deleted',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                ),
                content: Text(
                  'Record has been permanently removed from Firebase',
                  style: TextStyle(fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: FlatButton(
                      child: Text(
                        'Okay',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.lightBlue[800]),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ));
    });
  }

  fetchDropDownDataToDelete() async {
    List<Map> dataList = [];
    if (widget.deleteType == DeleteType.services) {
      List<Map> serviceList = [];

      QuerySnapshot data =
          await Firestore.instance.collection("My Services").getDocuments();
      print(data.documents);
      data.documents.forEach((element) {
        // print(element.data);
        serviceList
            .add({"name": element.data['Service'], "id": element.documentID});
      });

      dataList = serviceList;
    } else if (widget.deleteType == DeleteType.fitting) {
      List<Map> serviceList = [];

      QuerySnapshot data =
          await Firestore.instance.collection("Fitting").getDocuments();
      print(data.documents);
      data.documents.forEach((element) {
        // print(element.data);
        serviceList
            .add({"name": element.data['Fittings'], "id": element.documentID});
      });

      dataList = serviceList;
    } else if (widget.deleteType == DeleteType.booking) {
      List<Map> serviceList = [];
      await Firestore.instance.collection('User').getDocuments().then((event) {
        event.documents.forEach((element1) async {
          await Firestore.instance
              .collection("User")
              .document(element1.documentID.toString())
              .collection("Booking")
              .getDocuments()
              .then((value) {
            value.documents.forEach((element2) {
              serviceList.add({
                "name": element2.data['Fitting'],
                "id": element2.documentID,
                "userId": element1.documentID.toString(),
              });
            });
          });
        });
      });
      dataList = serviceList;
    } else if (widget.deleteType == DeleteType.user) {
      List<Map> serviceList = [];

      QuerySnapshot data =
          await Firestore.instance.collection("User").getDocuments();
      print(data.documents);
      data.documents.forEach((element) {
        // print(element.data);
        serviceList
            .add({"name": element.data['Email'], "id": element.documentID});
      });

      dataList = serviceList;
    }
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    // fetchDropDownDataToDelete();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
      ),
      //PAGE UI
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    //SERVICE TEXT FIELD
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 30, bottom: 20),
                      child: Text(
                        'Select an item to remove',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w500),
                      ),
                    ),

                    FutureBuilder(
                      future: fetchDropDownDataToDelete(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          List<Map> datalist = snapshot.data;

                          return Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                            child: DropdownButton(

                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500),
                              hint: Text('Select'),
                              elevation: 1,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 30,
                                color: Colors.lightBlue[700],
                              ),

                              value: selectedDataId,
                              items: List.generate(
                                snapshot.data.length,
                                (index) => DropdownMenuItem(
                                  child: Text(
                                    datalist[index]['id'],
                                  ),
                                  value: datalist[index]['id'],
                                ),
                              ),

                              onChanged: (value) {
                                setState(() {
                                  // selectedDataName = value;
                                  selectedDataId = value;
                                  selectedDataName = datalist
                                      .where((element) => element['id'] == value)
                                      .toList()[0]['name'];
                                  if (widget.deleteType == DeleteType.booking) {
                                    selectedBookingUserId = datalist
                                        .where(
                                            (element) => element['name'] == value)
                                        .toList()[0]['userId'];
                                  }
                                });
                              },
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 0, bottom: 0),
                            child: Text(
                              'Wait For a moment while fetching record from Firebase',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),

      //FLOATING BUTTON NEXT
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            child: FloatingActionButton.extended(
              backgroundColor: Colors.blueGrey[900],
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await deleteData();
                  clearText();
                  setState(() {});
                }
              },
              label: Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
