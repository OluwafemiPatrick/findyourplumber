import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {

  final String date;
  final String description;
  final String fitting;
  final String location;
  final String maxPrice;
  final String minPrice;
  final String service;
  final String estimatedPrice;
  final String time;

  const BookingDetailsPage(
      {Key key,
        this.date,
        this.description,
        this.fitting,
        this.location,
        this.maxPrice,
        this.minPrice,
        this.service,
        this.estimatedPrice,
        this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      //APP BAR
      appBar: AppBar(
        title: Text(service ?? 'Booking Details', style: TextStyle(fontSize: 21),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),

      //BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [

              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height * 0.80,
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
                child: Column(

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),),
                          SizedBox(height: 20),
                          Text(date + '  |  ' + time, style: TextStyle(fontSize: 21, color: Colors.grey[600]),),

                          SizedBox(height: 30),
                          Text('Fitting', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400, color: Colors.grey[600]),),
                          SizedBox(height: 10),
                          Text(fitting, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),),
                          SizedBox(height: 20),


                          Text('Location', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400, color: Colors.grey[600]),),
                          SizedBox(height: 10),
                          Text(location, style: TextStyle(fontSize: 23),),
                          SizedBox(height: 20),

                          Text('Description', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400, color: Colors.grey[600]),),
                          SizedBox(height: 10),
                          Text(description, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, height: 1.5),),
                          SizedBox(height: 20),

                          Divider(
                            color: Colors.black,
                          ),

                          SizedBox(height: 20),
                          Text('RM '+ estimatedPrice, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),),
                          SizedBox(height: 20),


                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
