import 'package:card_master/admin/pages/navigation/bottom_navigation.dart';
import 'package:card_master/admin/provider/websockets.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 400,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10.0.ws,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            Expanded(
              child: Container(
                  alignment: Alignment.topRight,
                  child: (UserSessionManager.getPrivileged()!)
                      ? IconButton(
                          onPressed: () {
                            Websockets.setupWebSockets();
                            Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const BottomNavigation(),
                              ),
                            );
                          },
                          icon: Icon(Icons.admin_panel_settings,
                              color: ColorSelect.blueAccent),
                          iconSize: 5.0.fs,
                        )
                      : const SizedBox.shrink()),
            )
          ],
        ));
  }
}
