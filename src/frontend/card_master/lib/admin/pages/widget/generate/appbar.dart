import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:card_master/admin/pages/widget/generate/iconbutton.dart';

AppBar generateAppBar(BuildContext context) {
  return SizerUtil.deviceType == DeviceType.mobile
      ? AppBar(
          leading: Icon(
            Icons.credit_card,
            size: 20.sp,
          ),
          toolbarHeight: 7.h,
          title: Text(
            "Admin",
            style:
                TextStyle(color: Theme.of(context).focusColor, fontSize: 20.sp),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: [
            generateIconButton(context, Icons.settings, "/settings"),
            generateIconButton(context, Icons.bookmark, "/reservations"),
            generateIconButton(context, Icons.account_box, "/users"),
            generateIconButtonRoute(
              context,
              Icons.logout,
              () => Navigator.pushNamedAndRemoveUntil(
                  context, "/client", (Route<dynamic> route) => false),
            )
          ],
        )
      : AppBar(
          leading: Icon(Icons.credit_card, size: 15.sp),
          toolbarHeight: 8.h,
          title: Text(
            "Admin",
            style:
                TextStyle(color: Theme.of(context).focusColor, fontSize: 18.sp),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: [
            generateIconButton(context, Icons.settings, "/settings"),
            generateIconButton(context, Icons.bookmark, "/reservations"),
            generateIconButton(context, Icons.account_box, "/users"),
            generateIconButtonRoute(
              context,
              Icons.logout,
              () => Navigator.pushNamedAndRemoveUntil(
                  context, "/client", (Route<dynamic> route) => false),
            )
          ],
        );
}
