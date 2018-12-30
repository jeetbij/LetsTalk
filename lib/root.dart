import 'package:flutter/material.dart';
import 'auth.dart';
import 'login.dart';
import 'dashboard.dart';
import 'homepage.dart';

class Root extends StatefulWidget {
  Root({Key key, this.auth}) : super(key: key);
  BaseAuth auth;
  _RootState createState() => _RootState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootState extends State<Root> {

  AuthStatus _authStatus = AuthStatus.notSignedIn;
  
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;   
      });
    });
  }

  void _onSignedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context){
    if(_authStatus == AuthStatus.notSignedIn){
      return Login(auth: widget.auth, onSignedIn: _onSignedIn,);
    }else{
      // return Dashboard(auth: widget.auth, onSignedOut: _signedOut,);
      return HomePage(auth: widget.auth, onSignedOut: _signedOut,);
    }
  }
}