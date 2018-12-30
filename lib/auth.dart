import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmail(String email, String password);
  Future<String> registerWithEmail(String email ,String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  Future<String> signInWithEmail(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> registerWithEmail(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> currentUser() async {
    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return user.uid;
    }catch(e){
      print(e);
    }
  }
  
  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}