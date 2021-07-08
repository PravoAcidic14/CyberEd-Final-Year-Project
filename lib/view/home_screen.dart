import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/user_auth.dart';
import 'package:provider/provider.dart';

class HomeScreenView extends StatefulWidget {
  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: ElevatedButton(
        onPressed: () {
          context.read<UserAuth>().signOut();
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
