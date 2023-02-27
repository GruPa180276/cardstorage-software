import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

Expanded generateButtonRound(BuildContext context, String buttonText,
    IconData buttonIcon, String route) {
  return Expanded(
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(double.infinity, 7.h),
        maximumSize: Size(double.infinity, 7.h),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      icon: SizerUtil.deviceType == DeviceType.mobile
          ? Icon(
              buttonIcon,
              size: 26.0.sp,
            )
          : Icon(
              buttonIcon,
              size: 18.0.sp,
            ),
      label: SizerUtil.deviceType == DeviceType.mobile
          ? Text(buttonText, style: TextStyle(fontSize: 20.sp))
          : Text(buttonText, style: TextStyle(fontSize: 15.sp)),
    ),
  );
}

ElevatedButton generateButtonRectangle(
  BuildContext context,
  String buttonText,
  Function()? onpressd,
) {
  return ElevatedButton(
    onPressed: onpressd,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      minimumSize: Size(double.infinity, 7.h),
      maximumSize: Size(double.infinity, 7.h),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      foregroundColor: Theme.of(context).focusColor,
    ),
    child: SizerUtil.deviceType == DeviceType.mobile
        ? Text(
            buttonText,
            style: TextStyle(fontSize: 20.sp),
            textAlign: TextAlign.center,
          )
        : Text(
            buttonText,
            style: TextStyle(fontSize: 15.sp),
            textAlign: TextAlign.center,
          ),
  );
}
