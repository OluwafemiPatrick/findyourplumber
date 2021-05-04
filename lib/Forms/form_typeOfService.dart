

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/db_booking_details.dart';
import 'package:findyourplumber/Forms/form_location.dart';

class TypeOfService extends StatefulWidget {
  final BookingDetails booking;
  TypeOfService({Key key, @required this.booking}) : super(key: key);

  @override
  _TypeOfServiceState createState() => _TypeOfServiceState();
}

class Service {
  String id;
  String name;
  String price;
  String maxPrice;
  String minPrice;

  Service(this.id, this.name, this.price, this.maxPrice, this.minPrice);
}

class _TypeOfServiceState extends State<TypeOfService> {
  // List<Service> _service;
  // List<Service> _service = Service.getService();
  List<DropdownMenuItem<Service>> _dropdownMenuItems;
  Service _selectedService;
  String _selectedServiceName;

  Future<List<Service>> getServiceDropdownData() async {
    List<Service> serviceList = [];
    QuerySnapshot data =
    await Firestore.instance.collection("My Services").getDocuments();
    data.documents.forEach((element) {
      serviceList.add(
        Service(
          element.documentID.toString(),
          element['Service'],
          element.data['Estimated Price'],
          element.data['Max Price'],
          element.data['Min Price'],
        ),
      );
    });
    return serviceList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '1  of  5',
            style: TextStyle(
              fontSize: 21,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 28,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                })
          ],
          backgroundColor: Colors.lightBlue[800],
        ),

        //UI OF THE PAGE
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 15, top: 25),
                    child: Text('Service',
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      margin: EdgeInsets.all(0),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: FutureBuilder<List<Service>>(
                          future: getServiceDropdownData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton(
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500),
                                hint: Text('Select a service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                elevation: 1,
                                isExpanded: true,
                                underline: SizedBox(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 30,
                                  color: Colors.lightBlue[800],
                                ),
                                items: snapshot.data
                                    .map((e) => DropdownMenuItem(
                                  value: e.name,
                                  child: Text(e.name ?? ''),
                                  onTap: () {
                                    widget.booking.servicePrice = e.price;
                                    widget.booking.maxPrice = e.maxPrice;
                                    widget.booking.minPrice = e.minPrice;
                                  },
                                ))
                                    .toList(),
                                value: _selectedServiceName,
                                onChanged: (value) {
                                  setState(() {
                                    // _selectedService = value;
                                    _selectedServiceName = value;
                                    _selectedService = snapshot.data
                                        .where((element) => element.name == value)
                                        .toList()[0];
                                  });
                                },
                              );
                            } else {
                              return Center(
                                child:
                                Text('Wait while fetching services from database.'),
                              );
                            }
                          }),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text('Select a service that you would like us to provide.',
                        style: TextStyle(
                            fontSize: 21,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[500])),
                  ),
                ])),

        //FLOATING BUTTON NEXT
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Semantics(
              child: FloatingActionButton.extended(
                backgroundColor: Colors.lightBlue[800],
                onPressed: () {
                  widget.booking.typeOfService = _selectedService.name;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Location(booking: widget.booking)));
                },
                label: Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ),
            )
          ],
        ));
  }
}
