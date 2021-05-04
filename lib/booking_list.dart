import 'package:findyourplumber/user_update_booking.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Forms/form_typeOfService.dart';
import 'provider.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:findyourplumber/db_booking_details.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final newBooking =
  new BookingDetails(null, null, null, null, null, null, null, null, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],



        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: StreamBuilder(
              stream: getUsersBookingStreamSnapshots(context),
              builder: (context, snapshot) {
                //IN CASE THERE IS NO DATA
                if (!snapshot.hasData)
                  return Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ));

                //LIST BUILDER
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot booking = snapshot.data.documents[index];

                      String service = booking['Service'] ?? '';
                      String price = booking['Estimated Price'] ?? '';
                      String full = 'The total amount for ' +
                          (service ?? '') +
                          ' is : ' +
                          (price ?? '');
                      String minPrice = booking['Min Price'];
                      String maxPrice = booking['Max Price'];
                      String bookingId = booking.documentID;

                      DateTime scheduleTime = DateTime.parse(
                          booking['Date'] + " " + booking['Time']);

                      //UI OF THE LIST
                      return Column(
                        children: [

                          Container(
                              margin: EdgeInsets.only(left: 30, top: 25, right: 30),
                              height: MediaQuery.of(context).size.height * 0.53,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [

                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 0.5,
                                  ),
                                ],
                              ),

                              //SERVICE DATA
                              child: ListView(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(booking['Service'] ?? '', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),),

                                      //LOCATION DATA
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_rounded, color: Colors.lightBlue[800]),
                                          SizedBox(width: 20),
                                          Text(booking['Location'] ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),

                                      //DATA AND TIME DATA
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_rounded, color: Colors.lightBlue[800]),
                                          SizedBox(width: 20),
                                          Text(booking['Date'] + '  |  ' + booking['Time'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[700]),),
                                        ],
                                      ),

                                      //Fitting DATA
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Icon(Icons.plumbing_rounded,
                                              color: Colors.lightBlue[800]),
                                          SizedBox(width: 20),
                                          Text(booking['Fitting'] ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[700]),),
                                        ],
                                      ),

                                      SizedBox(height: 30),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Your issue: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),),
                                          SizedBox(height: 10),
                                          Text(booking['Description'] ?? '', style: TextStyle(height: 1.5, fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[700]),),
                                        ],
                                      ),



                                      Column(children: [
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(right: 1),
                                              child: FlatButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder:
                                                            (_) => AlertDialog(
                                                          title: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                                fontSize:
                                                                24),
                                                          ),
                                                          content: Text(
                                                            'Are you sure you want to cancel your booking?',
                                                            style: TextStyle(
                                                                height: 1.5,fontSize:
                                                            20),
                                                          ),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  14)),
                                                          actions: <
                                                              Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  right:
                                                                  15),
                                                              child:
                                                              FlatButton(
                                                                child:
                                                                Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      fontSize:
                                                                      21,
                                                                      color:
                                                                      Colors.red[700]),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  var uid = await Provider.of(context)
                                                                      .auth
                                                                      .getCurrentUID();
                                                                  final doc = Firestore
                                                                      .instance
                                                                      .collection('User')
                                                                      .document(uid)
                                                                      .collection('Booking')
                                                                      .document(booking.documentID);
                                                                  doc.delete().whenComplete(
                                                                          () {
                                                                        print(
                                                                            'deleted');
                                                                      });
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ));
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 21,
                                                        color: Colors.red[700]),
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(right: 1),
                                              child: FlatButton(
                                                  onPressed: () async {
                                                    if (DateTime.now().difference(scheduleTime).inDays == 0) {
                                                      await showDialog(context: context,
                                                          builder: (_) => AlertDialog(

                                                            title: Text("Pay", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 21),),
                                                            content: Text("The total amount you were charged for is:  RM $price", style: TextStyle(fontSize: 24, height: 1.5, fontWeight: FontWeight.w500),),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(14)),

                                                            actions: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 15), child:
                                                              FlatButton(child:
                                                              Text('Make Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: Colors.lightBlue[700]),),

                                                                onPressed:
                                                                    () async {
                                                                  await InAppPayments.setSquareApplicationId(
                                                                      'sandbox-sq0idb-wD7ey_CuPQ__Lp2KwKSR5g');
                                                                  await InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess:
                                                                      (CardDetails result) async {
                                                                    try {
                                                                      var uid = await Provider.of(context).auth.getCurrentUID();
                                                                      final doc = Firestore.instance.collection('User').document(uid).collection('Booking').document(booking.documentID);
                                                                      doc.delete().whenComplete(() {
                                                                        print('deleted');
                                                                      });

                                                                      InAppPayments.completeCardEntry(
                                                                        onCardEntryComplete: () => print('Payment Confirmed'),
                                                                      );
                                                                    } on Exception catch (ex) {
                                                                      print('There was an error');
                                                                      InAppPayments.showCardNonceProcessingError(ex.toString());
                                                                    }
                                                                  });
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              )
                                                            ],
                                                          ));
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UserUpdateBooking(
                                                                bookingId: bookingId,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    DateTime.now()
                                                        .difference(
                                                        scheduleTime)
                                                        .inDays ==
                                                        0
                                                        ? 'Proceed'
                                                        : 'ReSchedule', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21, color: Colors.lightBlue[800]),
                                                  )
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                    ],
                                  ),
                                )
                              ])),
                        ],
                      );
                    });
              }),
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Semantics(
              label: 'Book a Plumber',
              child: FloatingActionButton(
                backgroundColor: Colors.lightBlue[700],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TypeOfService(booking: newBooking)));
                },
                child: const Icon(
                  Icons.add,
                  size: 32,
                ),
              ),
            )
          ],
        ));
  }
}

//STREAM BUILDER TO GET USER DATA
Stream<QuerySnapshot> getUsersBookingStreamSnapshots(
    BuildContext context) async* {
  final uid = await Provider.of(context).auth.getCurrentUID();
  yield* Firestore.instance
      .collection('User')
      .document(uid)
      .collection('Booking')
      .snapshots();
}
