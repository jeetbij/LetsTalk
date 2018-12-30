import 'package:flutter/material.dart';
import 'login.dart';
import 'auth.dart';
import 'root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetsTalk',
      home: Root(auth: Auth(),)
    );
  }
}
