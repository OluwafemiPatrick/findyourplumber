
import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  Stream <String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
      (FirebaseUser user) => user?.uid,
  );

  //GET UID
  Future <String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  //GET CURRENT USER
  Future getCurrentUser() async {
    return (await _firebaseAuth.currentUser());
  }

  //SIGN UP WITH EMAIL & PASSWORD
  Future <String> createUserWithEmailAndPassword(String email, String password, String name) async {
    prefs = await SharedPreferences.getInstance();
    final FirebaseUser currentUser = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password)).user;

    if (currentUser.isEmailVerified){

    }

    //UPDATE THE USERNAME
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    prefs.setString("currentUser", currentUser.uid.toString());
    return currentUser.uid;



  }

  //SIGN IN WITH EMAIL & PASSWORD
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    prefs = await SharedPreferences.getInstance();

    var dummy = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    var userId = dummy.user.uid;
    prefs.setString("currentUser", userId);
    return userId;
  }

  //SIGN OUT
  signOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("currentUser");
    prefs.remove("userName");

    return _firebaseAuth.signOut();
  }

}

  //EMAIL VALIDATOR
  class EmailValidator {
    static String validate(String value){
      if(value.isEmpty){
        return 'Please enter an Email';
      }
      return null;
    }
  }

  //PASSWORD VALIDATOR
  class PasswordValidator {
    static String validate(String value){
      if(value.isEmpty){
        return 'Please enter a Password';
      }
      return null;
    }
  }

  //NAME VALIDATOR
  class NameValidator {
    static String validate(String value){
      if(value.isEmpty){
        return 'Please enter a Name';
      }
      return null;
    }
  }
