import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

enum EditType {
  user,
  fitting,
  booking,
  services,
}

enum OperationType {
  add,
  edit,
}

class AddEditForm extends StatefulWidget {
  final EditType editType;
  final OperationType operationType;

  const AddEditForm(
      {Key key, @required this.editType, @required this.operationType})
      : assert(editType != null && operationType != null);
  @override
  _AddEditFormState createState() => _AddEditFormState();
}

class _AddEditFormState extends State<AddEditForm> {
  String service, description;
  String selectedDataName;
  String selectedDataId;
  String selectedBookingUserId;
  String serviceImageUrl;

  String minPrice;
  String maxPrice;

  final _formKey = GlobalKey<FormState>();
  final serviceField = TextEditingController();
  final minPriceField = TextEditingController();
  final maxPriceField = TextEditingController();
  final descriptionField = TextEditingController();

  getService(service) {
    this.service = service;
  }

  getMinPrice(price) {
    this.minPrice = price;
  }

  getMaxPrice(price) {
    this.maxPrice = price;
  }

  getDescription(description) {
    this.description = description;
  }

  fetchDropDownDataToDelete() async {
    List<Map> dataList = [];
    if (widget.editType == EditType.services) {
      List<Map> serviceList = [];
      QuerySnapshot data =
          await Firestore.instance.collection("My Services").getDocuments();
      print(data.documents);
      data.documents.forEach((element) {
        print(element.data);
        serviceList
            .add({"name": element.data['Service'], "id": element.documentID});
      });
      dataList = serviceList;
    } else if (widget.editType == EditType.fitting) {
      List<Map> serviceList = [];
      QuerySnapshot data =
          await Firestore.instance.collection("Fitting").getDocuments();
      print(data.documents);
      data.documents.forEach((element) {
        print(element.data);
        serviceList
            .add({"name": element.data['Fittings'], "id": element.documentID});
      });
      dataList = serviceList;
    } else if (widget.editType == EditType.booking) {
      List<Map> serviceList = [];
      Firestore.instance.collection('User').getDocuments().then((event) {
        event.documents.forEach((element1) {
          Firestore.instance
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
    }
    return dataList;
  }

  Random r = Random();

  int getEstimatedPrice(double minPrice, double maxPrice) {
    if (minPrice > maxPrice) {
      double a = minPrice;
      minPrice = maxPrice;
      maxPrice = a;
    }
    int price = r.nextInt(maxPrice.toInt());
    if (price < minPrice.toInt()) {
      price = getEstimatedPrice(minPrice, maxPrice);
    }
    return price;
  }

  setData() {
    DocumentReference documentReference;
    Map<String, dynamic> recordData;
    if (widget.editType == EditType.services) {
      documentReference =
          Firestore.instance.collection('My Services').document(selectedDataId);

      //MAP
      recordData = {
        'Service': service,
        'Estimated Price':
            getEstimatedPrice(double.parse(minPrice), double.parse(maxPrice))
                .toString(),
        'Description': description,
        'image': serviceImageUrl,
        'Min Price': minPrice,
        'Max Price': maxPrice,
      };
    } else if (widget.editType == EditType.fitting) {
      documentReference =
          Firestore.instance.collection('Fitting').document(selectedDataId);

      //MAP
      recordData = {
        'Fittings': service,
      };
    }
    documentReference.setData(recordData).whenComplete(() async {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(
                  'Set',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                ),
                content: Text(
                  'Data has been set in Firebase',
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
                            color: Colors.lightBlue[900]),
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

  void clearText() {
    serviceField.clear();
    minPriceField.clear();
    maxPriceField.clear();
    descriptionField.clear();
    selectedDataId = null;
    selectedDataName = null;
    selectedBookingUserId = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
      ),

      //PAGE UI
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      SizedBox(height: 30),
                      Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
                          child: widget.operationType == OperationType.edit
                              ? Text('Select an item to Edit', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),)
                              : Text('Add some data into Firebase', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500))
                      ),

                      widget.operationType == OperationType.edit
                          ? FutureBuilder(
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

                                      value: selectedDataName,
                                      items: List.generate(
                                        snapshot.data.length,
                                        (index) => DropdownMenuItem(
                                          child: Text(
                                            datalist[index]['name'],
                                          ),
                                          value: datalist[index]['name'],
                                        ),
                                      ),

                                      onChanged: (value) {
                                        setState(() {
                                          selectedDataName = value;
                                          // selectedDataId = value;
                                          selectedDataId = datalist
                                              .where((element) =>
                                                  element['name'] == value)
                                              .toList()[0]['id'];

                                          if (widget.editType ==
                                              EditType.booking) {
                                            selectedBookingUserId = datalist
                                                .where((element) =>
                                                    element['name'] == value)
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
                            )
                          : SizedBox(),

                      SizedBox(height: 10),

                      widget.editType == EditType.fitting
                          ? SizedBox()
                          : FlatButton.icon(
                              onPressed: () {
                                ImagePicker.platform
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) async {
                                  String imageName = DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString();
                                  StorageTaskSnapshot taskDetails =
                                      await FirebaseStorage.instance
                                          .ref()
                                          .child("Services")
                                          .child(imageName)
                                          .putFile(File(value.path))
                                          .onComplete;

                                  FirebaseStorage.instance
                                      .ref()
                                      .child("Services")
                                      .child(imageName)
                                      .getDownloadURL()
                                      .then((value) {
                                    setState(() {
                                      serviceImageUrl = value;
                                    });
                                  });
                                });
                              },
                              splashColor: Colors.grey[100],
                              icon: Icon(Icons.folder_open),
                              label: Text('Choose Image')),

                      SizedBox(height: 10),
                      widget.editType == EditType.services
                          ? serviceImageUrl != null && serviceImageUrl != ""
                              ? Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width - 40,
                                  color: Colors.grey[200],
                                  child: Image(
                                    image: NetworkImage(serviceImageUrl ?? ''),
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : SizedBox()
                          : SizedBox(),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some data';
                            }
                            return null;
                          },
                          controller: serviceField,
                          decoration: InputDecoration(
                            hintText: widget.editType == EditType.fitting
                                ? 'fitting'
                                : 'Service',
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
                          onChanged: (String service) {
                            getService(service);
                          },
                        ),
                      ),

                      //PRICE TEXT FIELD
                      widget.editType == EditType.fitting
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a min price range';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                controller: minPriceField,
                                decoration: InputDecoration(
                                  hintText: 'Minimum price',
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
                                onChanged: (String price) {
                                  getMinPrice(price);
                                },
                              ),
                            ),

                      widget.editType == EditType.fitting
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a Max price range';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                controller: maxPriceField,
                                decoration: InputDecoration(
                                  hintText: 'Maximum price',
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
                                onChanged: (String price) {
                                  getMaxPrice(price);
                                },
                              ),
                            ),

                      //DESCRIPTION TEXT FIELD
                      widget.editType == EditType.fitting
                          ? SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                controller: descriptionField,
                                decoration: InputDecoration(
                                  hintText: 'Description',
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
                                onChanged: (String description) {
                                  getDescription(description);
                                },
                              ),
                            ),
                    ],
                  )),
            ],
          ),
        ),
      ),

      //FLOATING BUTTON
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            child: FloatingActionButton.extended(
              backgroundColor: Colors.blueGrey[900],
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setData();
                  clearText();
                }
              },
              label: Text(
                'Set',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
