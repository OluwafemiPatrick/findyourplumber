
import 'package:flutter/material.dart';

import 'db_booking_details.dart';
import 'Forms/form_location.dart';
import 'rating.dart';

enum OpenFrom {
  user,
  admin,
}

class ServiceDetails extends StatefulWidget {


  final OpenFrom openFrom;
  final String serviceName;
  final String servicePrice;
  final String description;
  final String serviceImage;
  final String minPrice;
  final String maxPrice;
  int ratingNumber;

  ServiceDetails(
      this.openFrom, {
        Key key,
        this.serviceName,
        this.servicePrice,
        this.description,
        this.serviceImage,
        this.minPrice,
        this.maxPrice,
        this.ratingNumber
      }) : super(key: key);


  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),

        body: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [

              //IMAGE VIEWER
              Container(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: InteractiveViewer(
                            constrained: false,
                            child: Image(
                              image: NetworkImage(widget.serviceImage),
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                    );
                  },

                  //IMAGE PROPERTIES
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height / 3,
                    color: Colors.grey[200],
                    child: Image(
                      image: NetworkImage(widget.serviceImage),
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height / 5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [

                    SizedBox(height: 30),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.14,
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
                        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.serviceName, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
                                Row(
                                  children: [
                                    Icon(Icons.star_rounded, color: Colors.orange, size: 28,),
                                    SizedBox(width: 5),
                                    Text("${widget.ratingNumber}", style: TextStyle(fontSize: 18),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Text('RM ' + widget.minPrice + ' - ' + widget.maxPrice, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.orange[900]),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.40,
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
                        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                            SizedBox(height: 15),
                            Text(widget.description, style: TextStyle(fontSize: 20, height: 1.5, color: Colors.grey[600]),),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.40,
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
                        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('How it works?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                            SizedBox(height: 15),
                            Text("  -  Click on the '+' icon",style: TextStyle(fontSize: 20, height: 1.5, color: Colors.grey[600]),),
                            Text("  -  Fill in your details for the booking",style: TextStyle(fontSize: 20, height: 1.5, color: Colors.grey[600]),),
                            Text("  -  You can reschedule the booking",style: TextStyle(fontSize: 20, height: 1.5, color: Colors.grey[600]),),
                            Text("  -  Get your service",style: TextStyle(fontSize: 20, height: 1.5, color: Colors.grey[600]),),
                            Text("  -  Make a Payment",style: TextStyle(fontSize: 20, height: 1.5, color: Colors.grey[600]),),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                    widget.openFrom == OpenFrom.admin
                    ? SizedBox()
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.15,
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

                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Rating((number) {
                                setState(() {
                                  widget.ratingNumber = number;
                                  print(widget.ratingNumber);
                                });
                              }, 5),
                              SizedBox(
                                  height: 44,
                                  child: (widget.ratingNumber != null && widget.ratingNumber != 0)
                                      ? Text("You selected ${widget.ratingNumber} rating",
                                      style: TextStyle(fontSize: 18))
                                      : SizedBox.shrink()),
                            ],
                          ),
                        )
                    ),

                    SizedBox(height: 60),

                  ],
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            widget.openFrom == OpenFrom.admin
                ? SizedBox()
                : Semantics(
              label: 'Book a Plumber',
              child: FloatingActionButton(
                backgroundColor: Colors.lightBlue[700],
                onPressed: () {
                  final newBooking = new BookingDetails(null, null, null,
                      null, null, null, null, null, null);

                  newBooking.typeOfService = widget.serviceName;
                  newBooking.servicePrice = widget.servicePrice;
                  newBooking.maxPrice = widget.maxPrice;
                  newBooking.minPrice = widget.minPrice;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Location(booking: newBooking)));
                },
                child: const Icon(
                  Icons.add,
                  size: 32,
                ),
              ),
            )
          ],
        )

    );
  }
}

