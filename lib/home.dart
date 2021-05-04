
import 'package:findyourplumber/Chat/chatList.dart';
import 'package:findyourplumber/profile.dart';
import 'booking_list.dart';
import 'package:findyourplumber/services_list.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ServicesList(),
    Booking(),
    ChatList(),
    Profile(),
  ];

  //CHANGING THE STATE OF THE PAGE
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //BODY
      body: Container(
        color: Colors.white,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      //BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(

        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 35,), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded, size: 29), title: Text('Booking')),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded, size: 29), title: Text('Booking')),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded, size: 35), title: Text('Profile')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.lightBlue[800],
      ),
    );
  }
}
