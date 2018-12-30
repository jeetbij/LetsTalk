import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth.dart';

enum FormType {
  login,
  register
}

class Login extends StatefulWidget {
  Login({Key key, this.auth, this.onSignedIn}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _fname;
  String _lname, _uname;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }else{
      return false;
    }
  }

  void validateAndSubmit() async {
    if(validateAndSave()) {
      try{
        if(_formType == FormType.login){
          String userId = await widget.auth.signInWithEmail(_email, _password);
          print('Signed In: $userId');
        }else{
          String userId = await widget.auth.registerWithEmail(_email, _password);
          print("Registered: $userId");
          DatabaseReference fireRef = FirebaseDatabase.instance.reference().child("Users");
          dynamic user = {'userId': userId, 'uname': _uname, 'fname': _fname, 'lname': _lname};
          fireRef.child(userId).set(user);
        }
        widget.onSignedIn();
      }catch(e){
        print('Error: $e');
      }
    }
  }

  void moveToRegisterPage() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;    
    });
  }

  void moveToLoginPage() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildSignInInputs() + buildSubmitButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildSignInInputs() {
    if(_formType == FormType.login){
      return [
        TextFormField(
          decoration: InputDecoration(labelText: "Email"),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }else{
      return [
        TextFormField(
          decoration: InputDecoration(labelText: "User Name"),
          validator: (value) => value.isEmpty ? 'User Name can\'t be empty' : null,
          onSaved: (value) => _uname = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "First Name"),
          validator: (value) => value.isEmpty ? 'First Name can\'t be empty' : null,
          onSaved: (value) => _fname = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Last Name"),
          validator: (value) => value.isEmpty ? 'Last Name can\'t be empty' : null,
          onSaved: (value) => _lname = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Email"),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if(_formType == FormType.login){
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text("Login", style: TextStyle(fontSize: 20.0),),
        ),
        FlatButton(
          onPressed: moveToRegisterPage,
          child: Text("Register", style:TextStyle(fontSize: 20.0)),
        ),
      ];
    }else{
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text("Create an Account.", style: TextStyle(fontSize: 20.0),),
        ),
        FlatButton(
          onPressed: moveToLoginPage,
          child: Text("Have an Account? Login", style:TextStyle(fontSize: 20.0)),
        ),
      ];
    }
  }
}