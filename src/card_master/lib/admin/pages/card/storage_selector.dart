import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget buildStorageSelector(
  BuildContext context,
  String selectedStorage,
  List<String> dropDownValues,
  Function(String) setSelectedStorage,
  String selectorText,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      foregroundColor: Theme.of(context).focusColor,
      minimumSize: Size(double.infinity, 7.h),
      maximumSize: Size(double.infinity, 7.h),
    ),
    child: Wrap(
      children: <Widget>[
        SizerUtil.deviceType == DeviceType.mobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 20.sp,
                    Icons.filter_list,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text("$selectorText: $selectedStorage",
                      style: TextStyle(fontSize: 20.sp)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 14.sp,
                    Icons.filter_list,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text("$selectorText: $selectedStorage",
                      style: TextStyle(fontSize: 14.sp)),
                ],
              )
      ],
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Select Storage", style: TextStyle(fontSize: 15.sp)),
          actions: <Widget>[
            SizerUtil.deviceType == DeviceType.mobile
                ? Container(
                    width: 60.w,
                    height: 12.0.h,
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      value: selectedStorage,
                      items: dropDownValues.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem.toString(),
                                style: TextStyle(fontSize: 12.sp)));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setSelectedStorage(newValue!);
                      },
                    ),
                  )
                : Container(
                    width: 60.w,
                    height: 12.0.h,
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      value: selectedStorage,
                      items: dropDownValues.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem.toString(),
                                style: TextStyle(fontSize: 9.sp)));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setSelectedStorage(newValue!);
                      },
                    ),
                  ),
          ],
        ),
      );
    },
  );
}
