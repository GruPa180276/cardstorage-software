import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/client/provider/theme/theme_provider.dart';
import 'package:card_master/client/domain/persistent/app_preferences.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Settings> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = AppPreferences.getIsOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SizerUtil.deviceType == DeviceType.mobile
          ? AppBar(
              toolbarHeight: 7.h,
              title: Text(
                "Einstellungen",
                style: TextStyle(
                    color: Theme.of(context).focusColor, fontSize: 20.sp),
              ),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            )
          : AppBar(
              toolbarHeight: 8.h,
              title: Text(
                "Einstellungen",
                style: TextStyle(
                    color: Theme.of(context).focusColor, fontSize: 18.sp),
              ),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            ),
      body: Column(
        children: [Expanded(child: buildSettings(context))],
      ),
    );
  }

  Widget buildSettings(BuildContext context) {
    return SizerUtil.deviceType == DeviceType.mobile
        ? Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.mode,
                                size: 3.4.h,
                              ),
                              SizedBox(
                                width: 5.0.w,
                              ),
                              Text(' Dark-Mode',
                                  style: TextStyle(
                                      fontSize: 15.0.sp,
                                      color: Theme.of(context).primaryColor)),
                            ],
                          ),
                          Switch(
                              activeColor:
                                  Theme.of(context).secondaryHeaderColor,
                              value: isDark,
                              onChanged: (value) {
                                final provider = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false);
                                isDark = value;
                                setState(() {
                                  provider.toggleTheme(value);
                                });
                              }),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 1.h,
                ),
                generateButtonRectangle(
                  context,
                  "Abmelden",
                  () {
                    UserSessionManager.logout(context);
                  },
                ),
              ],
            ))
        : Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.mode,
                                size: 3.4.h,
                              ),
                              SizedBox(
                                width: 5.0.w,
                              ),
                              Text(' Dark-Mode',
                                  style: TextStyle(
                                      fontSize: 3.0.sp,
                                      color: Theme.of(context).primaryColor)),
                            ],
                          ),
                          Switch(
                              activeColor:
                                  Theme.of(context).secondaryHeaderColor,
                              value: isDark,
                              onChanged: (value) {
                                final provider = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false);
                                isDark = value;
                                setState(() {
                                  provider.toggleTheme(value);
                                });
                              }),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 1.h,
                ),
                generateButtonRectangle(
                  context,
                  "Abmelden",
                  () {
                    UserSessionManager.logout(context);
                  },
                ),
              ],
            ));
  }
}
