import 'package:findyourplumber/admin/admin_booking.dart';
import 'package:findyourplumber/admin/admin_fittings.dart';
import 'package:findyourplumber/admin/admin_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/intro.dart';
import 'admin_user.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //APP BAR
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          centerTitle: true,
          title: Text('Admin Panel',
              style: TextStyle(
                fontSize: 21,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => IntroPage()));
                  }),
            )
          ],
        ),


        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget> [

                //SERVICES SECTION
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.plumbing_rounded, size: 37, color: Colors.blueGrey[700]),
                          SizedBox(height: 15,),
                          Text('Services',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminManageService()));
                    },
                  ),
                ),

                //FITTINGS SECTION
                Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // if you need this
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    margin: EdgeInsets.all(8),
                    child: InkWell(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bathtub, size: 37, color: Colors.blueGrey[700]),
                            SizedBox(height: 15,),
                            Text('Fittings',
                              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminManageFitting()));
                      },
                    ),
                  ),

                ),

                //USERS SECTION
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_search_rounded, size: 37, color: Colors.blueGrey[700]),
                          SizedBox(height: 15,),
                          Text('Users',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminManageUser()));
                    },
                  ),
                ),

                //BOOKINGS SECTION
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 37, color: Colors.blueGrey[700]),
                          SizedBox(height: 15,),
                          Text('Bookings',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminManageBookings()));
                    },
                  ),
                ),

























































              ],
            ),
          ),
        )
    );
  }
}
