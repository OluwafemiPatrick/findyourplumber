

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findyourplumber/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:findyourplumber/auth_service.dart';
import 'package:findyourplumber/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//AUTH FORM TYPE FOR SIGN IN AND SIGN UP
enum AuthFormType { signIn, signUp }

class SignUp extends StatefulWidget {
  final AuthFormType authFormType;
  SignUp({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState(authFormType: this.authFormType);
}

class _SignUpState extends State<SignUp> {
  AuthFormType authFormType;
  _SignUpState({this.authFormType});

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  //SWITCH FORM STATE TO GO BETWEEN SIGN IN AND SIGN UP
  void switchFormState(String state) {
    _formKey.currentState.reset();
    if (state == 'signUp') {
      authFormType = AuthFormType.signUp;
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  //VALIDATION FOR TEXT FIELDS
  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  //SUBMIT BUTTON OPTIONS
  void submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);

          print('Sign in ID $uid');
          print(_email);

          _checkVerificationStatus();

        } else {

          auth.createUserWithEmailAndPassword(_email, _password, _name).then((value) {
            prefs.setString("userName", _name);
            Firestore.instance.collection("User").document(value.toString()).setData({
              "Email": _email,
              "Name": _name,
              "UserId": value.toString(),
            });

            Firestore.instance.collection("User").document(value.toString()).collection("Booking").startAt([]);

        //    Navigator.of(context).pushReplacementNamed('/home');

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailVerificationClass(_email)));

          });
        }
      } catch (e) {
        setState(() {
          _error = e.message;
        });
        print(e);
      }
    }
  }


  _checkVerificationStatus() async {
    // this checks if user email is confirmed before signing in
    final FirebaseUser user = (await _firebaseAuth.currentUser());

    await user.reload();
    if (user.isEmailVerified){
      Navigator.of(context).pushReplacementNamed('/home');
    } else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailVerificationClass(_email)));
    }
  }


  String _email, _password, _name, _error;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                //FIREBASE ERROR MESSAGE ALERT
                SizedBox(
                  height: _height * 0.025,
                ),
                showAlert(),

                //HEADER TEXT
                SizedBox(
                  height: _height * 0.15,
                ),
                buildHeaderText(),

                //TEXT FIELDS AND BUTTONS
                SizedBox(
                  height: _height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //FIREBASE ERROR MESSAGE ALERT
  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.grey[400],
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.error_outline_rounded,
                size: 26,
              ),
            ),
            Expanded(
                child: AutoSizeText(
              _error,
              maxLines: 3,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 26,
                  ),
                  onPressed: () {
                    setState(() {
                      _error = null;
                    });
                  }),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  //HEADER TEXT
  AutoSizeText buildHeaderText() {
    String _headerText;

    if (authFormType == AuthFormType.signUp) {
      _headerText = 'Create an account';
    } else {
      _headerText = 'Welcome Back!';
    }

    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 32, color: Colors.grey[850], fontWeight: FontWeight.w500),
    );
  }

  //INPUT SPECIFICATIONS
  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    //adding the name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(TextFormField(
        validator: NameValidator.validate,
        decoration: buildSignUpInputDecoration('Name'),
        onSaved: (value) => _name = value,

      ));
      textFields.add(SizedBox(height: 10));
    }

    //add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        decoration: buildSignUpInputDecoration('Email'),
        onSaved: (value) => _email = value,
      ),
    );

    textFields.add(SizedBox(height: 10));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        decoration: buildSignUpInputDecoration('Password'),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );

    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  //SUBMIT AND TOGGLE BUTTONS
  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Don't have an account yet? Sign Up";
      _newFormState = 'signUp';
      _submitButtonText = 'Sign In';
    } else {
      _switchButtonText = 'Already have an account" Sign In';
      _newFormState = 'signIn';
      _submitButtonText = 'Sign Up';
    }

    return [
      SizedBox(height: 8),
      Container(
        width: MediaQuery.of(context).size.height * 0.5,
        child: ButtonTheme(
          height: 60.0,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              color: Colors.lightBlue[800],
              child: Text(
                _submitButtonText,
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              onPressed: () {
                submit();
              }),
        ),
      ),
      SizedBox(height: 30),
      FlatButton(
        height: 10,
        child: Text(
          _switchButtonText,
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }

  //TEXT FIELD DESIGN
  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
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
    );
  }

}



class EmailVerificationClass extends StatefulWidget {

  final String email;
  EmailVerificationClass(this.email);

  @override
  _EmailVerificationClassState createState() => _EmailVerificationClassState();
}

class _EmailVerificationClassState extends State<EmailVerificationClass> {

  Timer timer;
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _sendEmailVerification();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    String email = widget.email;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: AppBar()),
      body: Container(
        padding: EdgeInsets.only(top: 200.0, bottom: 10.0),
        child: Column(
          children: [
            Text('We sent an email to $email \nKindly click on the link, then return to this page.',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,),
            Expanded(child: Container()),
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                color: Colors.lightBlue[800], child: Text(' Check verification status ',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal)),
                onPressed: () {
                  _checkEmailVerified();
                }
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _checkEmailVerified() async {

    final FirebaseUser user = (await _auth.currentUser());
    await user.reload();

    if (user.isEmailVerified){
      timer.cancel();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
    }
  }

  _sendEmailVerification() async {
    final FirebaseUser user = (await _auth.currentUser());
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _checkEmailVerified();
    });
  }

}


