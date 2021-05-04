import 'package:findyourplumber/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findyourplumber/Forms/form_typeOfService.dart';
import 'package:findyourplumber/db_booking_details.dart';

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  bool isSearched = false;
  List<DocumentSnapshot> searchedDataList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newBooking = new BookingDetails(
        null, null, null, null, null, null, null, null, null);

    return Scaffold(
        backgroundColor: Colors.grey[100],

        //FIREBASE INSTANCE
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('My Services').snapshots(),
          builder: (context, snapshot) {
            //EXCEPTION IN CASE IT'S EMPTY
            if (!snapshot.hasData)
              return Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ));

            //CREATING THE LIST OF SERVICES
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      // print(value);
                      searchedDataList.clear();
                      snapshot.data.documents.forEach((element) {
                        print(element.data['Service']);
                        if (element.data['Service']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase())) {
                          searchedDataList.add(element);
                        }
                      });
                      // print(searchedDataList[0].data);
                      setState(() {
                        isSearched = true;
                      });
                    },

                    decoration: InputDecoration(
                      hintText: 'Search here',
                      hintStyle: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w400, fontSize: 18),
                      prefixIcon: Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey[300],
                          )

                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.lightBlue[700],
                            width: 1.5,
                          )),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: isSearched
                          ? searchedDataList.length
                          : snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot service;

                        if (isSearched) {
                          service = searchedDataList[index];
                        } else {
                          service = snapshot.data.documents[index];
                        }

                        //DETAIL PAGE
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDetails(
                                  OpenFrom.user,
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


                          child: Padding(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Column(
                              children: [

                                SizedBox(height: 20),
                                Container(
                                  height: 110,
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

                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(service['Service'], style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
                                        SizedBox(height: 15,),
                                        Text('RM ' + service['Min Price'] + ' - ' + service['Max Price'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.orange[900]),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          },
        ),

        //FLOATING BUTTON
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Semantics(
              label: 'Book a Plumber',
              child: FloatingActionButton(
                backgroundColor: Colors.lightBlue[800],
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
