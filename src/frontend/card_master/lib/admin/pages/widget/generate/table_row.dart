import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

TableRow buildTableRow(
  BuildContext context,
  String labelName,
  dynamic value,
) {
  return SizerUtil.deviceType == DeviceType.mobile
      ? TableRow(
          children: [
            Text(
              labelName,
              style: TextStyle(fontSize: 15.sp),
            ),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 15.sp),
              textAlign: TextAlign.right,
            )
          ],
        )
      : TableRow(
          children: [
            Text(
              labelName,
              style: TextStyle(fontSize: 13.sp),
            ),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 13.sp),
              textAlign: TextAlign.right,
            )
          ],
        );
}
