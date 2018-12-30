import 'package:flutter/material.dart';

class Person {
  String uid;
  String uname;
}

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.fname}) : super(key: key);
  
  String fname;

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fname),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Scrollbar(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Material(
                color: Colors.deepPurple[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
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
                          child: Text("Hello ${widget.fname} Through each day our goal is to touch one’s heart;"),
                        ),
                      ],
                    ),
                    Column(
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
                          child: Text("encourage one’s mind nd inspire one’s soul. May u continually b blessed nd be a blessing to others!"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Form(
                child: ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Chat message',
                    ),
                  ),
                  trailing: Icon(Icons.send, color:Colors.deepPurple[400]),
                  onTap: null,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}