
import 'package:findyourplumber/admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                //TITLE
                SizedBox(height: _height * 0.12),
                Text('Welcome!',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),

                //DESCRIPTION
                SizedBox(height: _height * 0.03),
                AutoSizeText(
                    'Join the experience, get your plumbing needs',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.grey[600], fontWeight: FontWeight.w300, height: 1.5)),

                //GET STARTED BUTTON
                SizedBox(height: _height * 0.07),

                ButtonTheme(
                  minWidth: 250,
                  height: 60.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      color: Colors.lightBlue[800],
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 27),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/signUp');
                      }),
                ),

                //SIGN IN BUTTON
                SizedBox(height: _height * 0.07),
                FlatButton(
                  height: 10,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.lightBlue[800],
                        fontSize: 27,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                ),

                //ADMIN BUTTON
                SizedBox(height: _height * 0.12),
                FlatButton(
                  height: 10,
                  child: Text(
                    'Admin Panel',
                    style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Admin()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
