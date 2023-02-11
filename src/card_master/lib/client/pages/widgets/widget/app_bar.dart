import 'package:card_master/admin/pages/navigation/bottom_navigation.dart';
import 'package:card_master/client/domain/authentication/session_user.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  CustomAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 400,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Stack(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 33.0.fs,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.fromLTRB(0, 10.0.fs, 0, 0),
                child: (SessionUser.getPrivileged()!)
                    ? IconButton(
                        onPressed: () => Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                BottomNavigation(),
                          ),
                        ),
                        icon: Icon(Icons.admin_panel_settings,
                            color: Theme.of(context).primaryColor),
                        iconSize: 20.0.fs,
                      )
                    : const SizedBox.shrink())
          ],
        ));
  }
}
