import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'homepage.dart';

// final FirebaseApp app = FirebaseApp.configure(
//   name: 'app',
//   options: FirebaseOptions(
//     googleAppID: '1:134848764720:android:686d7a8695e0151e',
//     apiKey: 'AIzaSyDOYZX3qHQUjXY2TTMkKjdpoPzIdlXIl3w',
//     databaseURL: 'https://letstalk-ec04a.firebaseio.com',
//   )
// );

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.auth, this.onSignedOut}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  Item item;
  DatabaseReference itemRef;

  @override
    void initState() {
      super.initState();
      item = Item("", "", "");
      // final FirebaseDatabase database = FirebaseDatabase(app: app);
      itemRef = FirebaseDatabase.instance.reference().child('items');
    }

  final formKey = GlobalKey<FormState>();
  String _title, _body;

  void _signOut() async {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }catch(e){
      print(e);
    }
  }
  
  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.reset();
      return true;
    }else{
      return false;
    }
  }

  void validateAndSubmit() async {
    if(validateAndSave()) {
      widget.auth.currentUser().then((value) {
        var test = {'title':_title, 'body':_body};
        itemRef.child(value).push().set(test);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availMaxWidth = screenWidth - 100;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text("LetsTalk"),
        actions: <Widget>[
          FlatButton(
            child: Text("LogOut", style:TextStyle(fontSize: 17.0, color:Colors.white)),
            onPressed: _signOut,
          ),
          FlatButton(
            child: Text("Chat Page", style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => HomePage())
              );
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Body"),
                validator: (value) => value.isEmpty ? 'Body can\'t be empty' : null,
                onSaved: (value) => _body = value,
              ),
              RaisedButton(
                onPressed: validateAndSubmit,
                child: Text("Send", style: TextStyle(fontSize: 20.0),),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class Item {
  String key;
  String title;
  String body;

  Item(this.key, this.title, this.body);

  Item.fromSnapshot(DataSnapshot snapshot)
    : key = snapshot.value['key'],
    title = snapshot.value['title'],
    body = snapshot.value['body'];

  
  toJson() {
    return {
      "title": title,
      "body": body,
    };
  }
}










// Column(
//         children: <Widget>[
//           Card(
//             child: Container(
//               height: 80.0,
//               padding: EdgeInsets.all(10.0),
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     height: 60.0,
//                     width: 60.0,
//                     padding: EdgeInsets.all(2.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(
//                         color: Colors.white
//                       ),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(50.0)
//                       )
//                     ),
//                   child: Image.asset("assets/pied-piper02.png"),
//                   ),
//                   Container(
//                     constraints: BoxConstraints(
//                       maxWidth: availMaxWidth,
//                     ),
//                     padding: EdgeInsets.only(left: 20.0, right: 5.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text("Name", style: TextStyle(fontWeight: FontWeight.bold),)
//                       ],
//                     ),
//                   )
//                 ]
//               )
//             )
//           ),
//         ],
//       )