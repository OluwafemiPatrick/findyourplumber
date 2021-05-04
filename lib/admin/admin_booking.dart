import 'package:findyourplumber/admin/booking_details.dart';
import 'form_delete.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AdminManageBookings extends StatefulWidget {
  @override
  _AdminManageBookingsState createState() => _AdminManageBookingsState();
}

class _AdminManageBookingsState extends State<AdminManageBookings> {
  Stream<List<DocumentSnapshot>> getBookingsList() async* {
    List<DocumentSnapshot> bookingsData = [];
    Firestore.instance.collection('User').snapshots().listen((event) {
      event.documents.forEach((element1) {
        Firestore.instance
            .collection("User")
            .document(element1.documentID.toString())
            .collection("Booking")
            .snapshots()
            .forEach((element2) {
          element2.documents.forEach((element3) {
            bookingsData.add(element3);
          });
        });
      });
    });

    yield bookingsData;
  }

  @override
  void initState() {
    super.initState();
    getBookingsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text('Bookings', style: TextStyle(fontSize: 21,)),
        centerTitle: true,
      ),

      //FIREBASE INSTANCE
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: getBookingsList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ));

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                dynamic service = snapshot.data[index].data;
                print(service);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsPage(
                          estimatedPrice: service['Estimated Price'],
                          date: service['Date'],
                          description: service['Description'],
                          fitting: service['Fitting'],
                          location: service['Location'],
                          maxPrice: service['Max Price'],
                          minPrice: service['Min Price'],
                          service: service['Service'],
                          time: service['Time'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 25, top: 20, right: 25),
                      padding: EdgeInsets.only(left: 25, top: 25),
                      height: 100,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service['Service'], style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
                          SizedBox(height: 10,),
                          Text(service['Date'] + '  -  ' + service['Time'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey[500])),
                        ],
                      )
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
                          deleteType: DeleteType.booking,
                        )));
              }),
        ],
      ),
    );
  }
}
