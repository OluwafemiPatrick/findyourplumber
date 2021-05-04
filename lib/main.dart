
import 'package:findyourplumber/home.dart';
import 'package:findyourplumber/sign_up.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'intro.dart';
import 'package:findyourplumber/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signUp' : (BuildContext context) => SignUp(authFormType: AuthFormType.signUp,),
          '/signIn' : (BuildContext context) => SignUp(authFormType: AuthFormType.signIn,),
          '/home' : (BuildContext context) => HomeController(),
        },
        ),
    );
  }
}

//HOME CONTROLLER
class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : IntroPage();
          }
          return IntroPage();
          // return Container(
          //   color: Colors.white,
          //   child: CircularProgressIndicator(),
          // );
        }
    );
  }
}

