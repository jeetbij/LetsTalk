import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Person {
  String uid;
  String uname;
}

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.fname, this.uid, this.auth}) : super(key: key);
  
  String fname, uid;
  final BaseAuth auth;

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final formKey = GlobalKey<FormState>();
  String _message;
  List<Widget> _messages = [];

  String combineIds(f1, f2) {
    return f1.toString().compareTo(f2.toString()) > 0 ? f1.toString()+f2.toString() : f2.toString()+f1.toString();
  }

  Widget checkMessage(msgObject) {
    if(msgObject['sentTo'].toString() == widget.uid.toString()) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              maxWidth: 250.0
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              border: Border.all(
                color: Colors.black26,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0)
              )
            ),
            child: Text(msgObject['message'].toString()),
          ),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              maxWidth: 250.0
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black26,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0)
              )
            ),
            child: Text(msgObject['message'].toString()),
          ),
        ],
      );
    }
  }

  void sendMessgae() async {
    final form = formKey.currentState;
    dynamic msgObj;
    form.save();
    form.reset();
    if (form.validate()) {
      DatabaseReference dbRef = await FirebaseDatabase.instance.reference().child('thread');
      widget.auth.currentUser().then((value) {
        dbRef = dbRef.child(combineIds(widget.uid, value));
        msgObj = {'sentTo':widget.uid, 'message':_message, 'createdOn':DateTime.now().millisecondsSinceEpoch.toString()};
        dbRef.child(msgObj['createdOn']).set(msgObj);
        setState(() {
          _messages.add(checkMessage(msgObj));
        });        
      });
    }
  }

  @override
    void initState() {
      super.initState();
      widget.auth.currentUser().then((value) {
        dynamic dbRef = FirebaseDatabase.instance.reference().child('thread').child(combineIds(widget.uid, value)).orderByChild('createdOn');
        dbRef.once().then((DataSnapshot snapshot) {
          if(snapshot.value!=null){
            print(snapshot.value);
            var keys = snapshot.value.keys;
            var values = snapshot.value;
            List<Widget> messages = [];
            for(var key in keys){
              messages.add(checkMessage(values[key]));
            }
            setState(() {
              _messages = messages.reversed.toList();
            });
          }
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fname),
        backgroundColor: Colors.deepPurple[400],
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Scrollbar(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Material(
                  color: Colors.deepPurple[50],
                  child: _messages == [] ? Center(child: CircularProgressIndicator(),) : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _messages,
                  ),
                ),
              )
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: ListTile(
                  title: TextFormField(
                    validator: (value) => value.isEmpty ? null : null,
                    onSaved: (value) => _message = value,
                    decoration: InputDecoration(
                      hintText: 'Chat message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0)
                        )
                      )
                    ),
                  ),
                  trailing: Icon(Icons.send, color:Colors.deepPurple[400]),
                  onTap: sendMessgae,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}