import 'package:findyourplumber/Forms/form_fitting.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/db_booking_details.dart';

class Location extends StatefulWidget {
  final BookingDetails booking;
  Location({Key key, @required this.booking}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = widget.booking.location;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '2  of  5',
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
                    child: Text('Location', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.my_location_rounded),
                          hintText: 'Enter your location',
                          hintStyle: TextStyle(color: Colors.grey),
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
                                color: Colors.lightBlue[700],
                                width: 1.5,
                              )),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                        'Write down your location for the plumber know where to go.',
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
                  if (_formKey.currentState.validate()) {
                    widget.booking.location = _titleController.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TypeOfFitting(booking: widget.booking)));
                  }
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
