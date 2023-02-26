import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget buildSeacrh(
  BuildContext context,
  TextEditingController txtQuery,
  Function(String) search,
) {
  return Container(
    child: SizerUtil.deviceType == DeviceType.mobile
        ? TextFormField(
            style: TextStyle(
              fontSize: 10.sp,
            ),
            controller: txtQuery,
            onChanged: search,
            decoration: InputDecoration(
              hintText: "Search",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).secondaryHeaderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: SizedBox(
                height: 5.h,
                child: Icon(
                  Icons.search,
                  size: 16.sp,
                ),
              ),
              suffixIcon: SizedBox(
                height: 7.h,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 16.sp,
                  ),
                  onPressed: () {
                    txtQuery.text = '';
                    search(txtQuery.text);
                  },
                ),
              ),
            ),
          )
        : TextFormField(
            style: TextStyle(
              fontSize: 8.sp,
            ),
            controller: txtQuery,
            onChanged: search,
            decoration: InputDecoration(
              hintText: "Search",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).secondaryHeaderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: SizedBox(
                  height: 7.h,
                  width: 7.w,
                  child: Icon(
                    Icons.search,
                    size: 15.sp,
                  )),
              suffixIcon: SizedBox(
                height: 7.h,
                width: 7.w,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 15.sp,
                  ),
                  onPressed: () {
                    txtQuery.text = '';
                    search(txtQuery.text);
                  },
                ),
              ),
            ),
          ),
  );
}
