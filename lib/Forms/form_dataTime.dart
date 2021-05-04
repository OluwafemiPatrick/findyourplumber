import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/db_booking_details.dart';
import 'package:findyourplumber/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DateAndTime extends StatefulWidget {
  final BookingDetails booking;
  DateAndTime({Key key, @required this.booking}) : super(key: key);

  @override
  _DateAndTimeState createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  String _date = 'Select a Date';
  String _time = 'Select a Time';
  String selectedDate;
  String selectedTime;
  bool isSelectedDateToday = false;
  final db = Firestore.instance;
  @override
  void initState() {
    widget.booking.date = null;
    widget.booking.time = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(

        key: _formKey,
        backgroundColor: Colors.white,

        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '5  of  5',
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 15, top: 25),
                    child: Text('Date & Time', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),

                  SizedBox(height: 10,),

                  //GET DATE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 3.0,
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  minTime: DateTime.now(),
                                  theme: DatePickerTheme(
                                      itemHeight: 45,
                                      itemStyle: TextStyle(fontSize: 20),
                                      cancelStyle: TextStyle(color: Colors.lightBlue[800], fontSize: 20),
                                      doneStyle: TextStyle(color: Colors.lightBlue[800], fontSize: 20, fontWeight: FontWeight.w500)),
                                  showTitleActions: true, onConfirm: (date) {
                                    isSelectedDateToday = date.isToday;
                                    print('confirm $date');
                                    String year = date.year.toString();
                                    String month = "";

                                    if (date.month >= 1 && date.month <= 9) {
                                      month = "0" + date.month.toString();
                                    } else {
                                      month = date.month.toString();
                                    }

                                    String day = "";
                                    if (date.day >= 1 && date.day <= 9) {
                                      day = "0" + date.day.toString();
                                    } else {
                                      day = date.day.toString();
                                    }
                                    _date = '$year-$month-$day';
                                    selectedDate = _date;

                                    widget.booking.date = selectedDate;

                                    setState(() {});
                                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                            },

                            //DATE UI
                            child: Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.calendar_today_rounded, size: 23, color: Colors.lightBlue[800],),
                                            SizedBox(width: 20),
                                            Text(" $_date", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400, fontSize: 19),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.white,
                          ),

                          //GET TIME
                          SizedBox(height: 20.0),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 3.0,
                            onPressed: () {
                              DatePicker.showTime12hPicker(context,
                                  theme: DatePickerTheme(
                                      itemHeight: 45,
                                      itemStyle: TextStyle(fontSize: 20),
                                      cancelStyle: TextStyle(color: Colors.lightBlue[800], fontSize: 20),
                                      doneStyle: TextStyle(color: Colors.lightBlue[800], fontSize: 20, fontWeight: FontWeight.w500)),
                                  showTitleActions: true, onConfirm: (time) {
                                    String hour = "";
                                    String minute = "";

                                    if (isSelectedDateToday) {
                                      if (DateTime.now().difference(time) <= Duration(seconds: 1)) {
                                        if (time.hour <= 9 && time.hour >= 0) {
                                          hour = "0" + time.hour.toString();
                                        } else {
                                          hour = time.hour.toString();
                                        }
                                        if (time.minute <= 9 && time.minute >= 0) {
                                          minute = "0" + time.minute.toString();
                                        } else {
                                          minute = time.minute.toString();
                                        }
                                        _time = '$hour:$minute';
                                        selectedTime = _time;
                                        widget.booking.time = selectedTime;

                                        setState(() {});
                                      }
                                    } else {
                                      if (time.hour <= 9 && time.hour >= 0) {
                                        hour = "0" + time.hour.toString();
                                      } else {
                                        hour = time.hour.toString();
                                      }
                                      if (time.minute <= 9 && time.minute >= 0) {
                                        minute = "0" + time.minute.toString();
                                      } else {
                                        minute = time.minute.toString();
                                      }
                                      _time = '$hour:$minute';
                                      selectedTime = _time;
                                      widget.booking.time = selectedTime;

                                      setState(() {});
                                    }
                                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                              setState(() {});
                            },

                            //TIME UI
                            child: Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.access_time_rounded, size: 23, color: Colors.lightBlue[800],),
                                            SizedBox(width: 20),
                                            Text(" $_time", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400, fontSize: 19),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text('Pick a Date and Time, for your appointment',
                        style: TextStyle(
                            fontSize: 21,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[500])),
                  ),
                ])),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Semantics(
              child: FloatingActionButton.extended(
                backgroundColor: Colors.lightBlue[800],
                onPressed: () async {
                  print(widget.booking.date);
                  print(widget.booking.time);

                  if (widget.booking.date != null &&
                      widget.booking.date != "" &&
                      widget.booking.time != null &&
                      widget.booking.time != "" &&
                      widget.booking.description != null &&
                      widget.booking.description != "" &&
                      widget.booking.fitting != null &&
                      widget.booking.fitting != "" &&
                      widget.booking.location != null &&
                      widget.booking.location != "" &&
                      widget.booking.servicePrice != null &&
                      widget.booking.servicePrice != "" &&
                      widget.booking.typeOfService != null &&
                      widget.booking.typeOfService != "") {

                    //SAVE TO FIREBASE
                    final uid = await Provider.of(context).auth.getCurrentUID();
                    await db
                        .collection('User')
                        .document(uid)
                        .collection('Booking')
                        .add(widget.booking.toJson());

                    Navigator.of(context).popUntil((route) => route.isFirst);

                    Fluttertoast.showToast(
                      msg: "Thank you, your booking is complete!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green[700],
                      textColor: Colors.white,
                      fontSize: 17,
                    );

                  } else {
                    Fluttertoast.showToast(
                      msg: "Please fill in all of the data",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.blueGrey[600],
                      textColor: Colors.white,
                      fontSize: 17,
                    );
                  }
                },
                icon: Icon(Icons.check_rounded, size: 30,),
                label: Text('Book', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ),
            )
          ],
        ));
  }
}
