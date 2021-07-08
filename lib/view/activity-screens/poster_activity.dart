import 'package:flutter/material.dart';

class PosterActivity extends StatefulWidget {
  PosterActivity({Key key}) : super(key: key);

  @override
  _PosterActivityState createState() => _PosterActivityState();
}

class _PosterActivityState extends State<PosterActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.redAccent,
    );
  }
}