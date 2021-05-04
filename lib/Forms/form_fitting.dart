import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findyourplumber/Forms/form_description.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/db_booking_details.dart';

class TypeOfFitting extends StatefulWidget {
  final BookingDetails booking;
  TypeOfFitting({Key key, @required this.booking}) : super(key: key);

  @override
  _TypeOfFittingState createState() => _TypeOfFittingState();
}

class Fitting {
  String id;
  String name;

  Fitting(this.id, this.name);

}

class _TypeOfFittingState extends State<TypeOfFitting> {
  // List<Fitting> _fitting = Fitting.getFitting();
  List<DropdownMenuItem<Fitting>> _dropdownMenuItems;
  Fitting _selectedFitting;
  String _selectedFittingName;

  Future<List<Fitting>> getServiceDropdownData() async {
    List<Fitting> fittingList = [];
    QuerySnapshot data =
    await Firestore.instance.collection("Fitting").getDocuments();
    data.documents.forEach((element) {
      fittingList
          .add(Fitting(element.documentID.toString(), element['Fittings']));
    });
    return fittingList;
  }

  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem<Fitting>> buildDropDownMenuItems(List fitting) {
    List<DropdownMenuItem<Fitting>> items = List();
    for (Fitting fitting in fitting) {
      items.add(DropdownMenuItem(value: fitting, child: Text(fitting.name)));
    }
    return items;
  }

  onChangeDropdownItem(Fitting selectedFitting) {
    setState(() {
      _selectedFitting = selectedFitting;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '3  of  5',
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
                    child: Text('Fitting', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black)),
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
                      child: FutureBuilder<List<Fitting>>(
                          future: getServiceDropdownData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton(
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500),
                                hint: Text('Select a fitting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                                elevation: 1,
                                isExpanded: true,
                                underline: SizedBox(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 30,
                                  color: Colors.lightBlue[700],
                                ),
                                items: snapshot.data
                                    .map((e) => DropdownMenuItem(
                                  value: e.name,
                                  child: Text(e.name ?? ''),
                                ))
                                    .toList(),
                                value: _selectedFittingName,
                                onChanged: (value) {
                                  setState(() {
                                    // _selectedService = value;
                                    _selectedFittingName = value;
                                    _selectedFitting = snapshot.data
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
                    child: Text('Select the fitting you would like plumber to work on.',
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
                  widget.booking.fitting = _selectedFitting.name;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Description(booking: widget.booking)));
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
