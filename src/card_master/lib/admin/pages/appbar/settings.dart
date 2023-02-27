import 'package:card_master/admin/pages/widget/button.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:card_master/admin/provider/theme/themes.dart';
import 'package:card_master/admin/config/theme/app_preference.dart';
import 'package:sizer/sizer.dart';

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
        children: [Expanded(child: buildChangeThemeMode(context))],
      ),
    );
  }

  Widget buildChangeThemeMode(BuildContext context) {
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
                    child: SwitchListTile(
                        activeColor: Theme.of(context).primaryColor,
                        value: isDark,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Switch Theme Mode",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.sp,
                          ),
                        ),
                        onChanged: (value) {
                          AppPreferences.setIsOn(value);
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          isDark = value;
                          setState(() {
                            provider.toggleTheme(value);
                          });
                        })),
                SizedBox(
                  height: 1.h,
                ),
                generateButtonRectangle(
                  context,
                  "Zur Client Sicht",
                  () {
                    Navigator.of(context).pushNamed(
                      "/client",
                    );
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
                    child: SwitchListTile(
                        activeColor: Theme.of(context).primaryColor,
                        value: isDark,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          "Switch Theme Mode",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        onChanged: (value) {
                          AppPreferences.setIsOn(value);
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          isDark = value;
                          setState(() {
                            provider.toggleTheme(value);
                          });
                        })),
                SizedBox(
                  height: 1.h,
                ),
                generateButtonRectangle(
                  context,
                  "Zur Client Sicht",
                  () {
                    Navigator.of(context).pushNamed(
                      "/client",
                    );
                  },
                ),
              ],
            ));
  }
}
