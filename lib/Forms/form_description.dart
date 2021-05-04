import 'package:findyourplumber/Forms/form_dataTime.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/db_booking_details.dart';

class Description extends StatefulWidget {
  final BookingDetails booking;

  Description({Key key, @required this.booking}) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = widget.booking.description;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '4  of  5',
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

        //PAGE UI
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 15, top: 25),
                    child: Text('Description', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Type here',
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

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                        'Write down some more details about your plumbing issue.',
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
                    widget.booking.description = _titleController.text;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DateAndTime(booking: widget.booking)));
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
