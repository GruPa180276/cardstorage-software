import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

IconButton generateIconButton(
  BuildContext context,
  IconData icon,
  String route,
) {
  return SizerUtil.deviceType == DeviceType.mobile
      ? IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(route);
          },
          color: Theme.of(context).focusColor,
          icon: Icon(
            icon,
            size: 16.sp,
          ),
        )
      : IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(route);
          },
          color: Theme.of(context).focusColor,
          icon: Icon(
            icon,
            size: 12.sp,
          ),
        );
}
