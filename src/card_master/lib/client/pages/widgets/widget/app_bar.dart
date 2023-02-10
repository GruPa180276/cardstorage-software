import 'package:card_master/admin/pages/navigation/bottom_navigation.dart';
import 'package:card_master/client/provider/session_user.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  CustomAppBar({
    required this.title,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: AppBar(
          toolbarHeight: height,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Stack(
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: (SessionUser.getPrivileged()!)
                      ? IconButton(
                          onPressed: () =>
                              Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  BottomNavigation(),
                            ),
                          ),
                          icon: Icon(Icons.admin_panel_settings,
                              color: Theme.of(context).primaryColor),
                          iconSize: 30,
                        )
                      : const SizedBox.shrink())
            ],
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
