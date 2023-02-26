import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget buildAlertDialog(
  BuildContext context,
  String heading,
  String infoText,
  List<Widget> action,
) {
  return SizerUtil.deviceType == DeviceType.mobile
      ? AlertDialog(
          scrollable: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            heading,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 15.sp),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                infoText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 12.sp),
              ),
            ],
          ),
          actions: action,
        )
      : AlertDialog(
          scrollable: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            heading,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 14.sp),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                infoText,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 10.sp),
              ),
            ],
          ),
          actions: action,
        );
}
