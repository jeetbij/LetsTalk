import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.onSignedOut}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> _users = [CircularProgressIndicator()];

  void _signOut() async {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }catch(e){
      print(e);
    }
  }

  @override
    void initState() {
      super.initState();
      
      dynamic dbRef = FirebaseDatabase.instance.reference().child('Users').orderByChild('fname');
      dbRef.once().then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;
        var values = snapshot.value;
        List<Widget> users = [];
        for(var key in keys){
          print(key);
          // Person person;
          // person.uid = values[key]['userId'];
          // person.uname = values[key]['fname'];

          users.add(
            ListTile(
              isThreeLine: true,
              dense: true,
              leading: ExcludeSemantics(child: CircleAvatar(backgroundImage: AssetImage('assets/11.jpg'),),),
              title: Text(values[key]['fname'].toString()),
              subtitle: Text(values[key]['fname'].toString()+ ' ' +values[key]['lname'].toString()),
              trailing: Text("Today"),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatPage(fname: values[key]['fname']))
                );
              },
            ),
          );
          users.add(Divider(),);
        }

        setState(() {
          _users = users;
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text("LetsTalk"),
        actions: <Widget>[
          FlatButton(
            child: Text("LogOut", style:TextStyle(fontSize: 17.0, color:Colors.white)),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: _users
        ),
      ),
    );
  }
}