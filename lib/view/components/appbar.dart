import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final Color iconColor;
  final String route;
  final double height;

  const CustomAppBar({Key key, this.iconColor, this.route, @required this.height})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      toolbarHeight: preferredSize.height,
      elevation: 0,
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: iconColor,
          onPressed: () {
            Navigator.pop(context, ModalRoute.withName(route));
          }),
      backgroundColor: Colors.transparent,
    );

    return appbar;
  }

  getAppBarHeight(AppBar appbar) {
    var appBarHeight = appbar.preferredSize.height;
    return appBarHeight;
  }
}
