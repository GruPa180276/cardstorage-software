import 'package:card_master/client/domain/authentication/user_session_manager.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/iconbutton.dart';
import 'package:sizer/sizer.dart';

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
              () => UserSessionManager.logout(context),
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
            generateIconButton(context, Icons.logout, "/logout"),
          ],
        );
}
