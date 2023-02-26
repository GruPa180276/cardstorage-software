import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class GenerateReloadButton extends StatelessWidget {
  late Function callBack;

  GenerateReloadButton(Function state) {
    callBack = state;
  }

  @override
  Container build(BuildContext context) {
    return SizerUtil.deviceType == DeviceType.mobile
        ? Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 10.h,
                  width: 15.w,
                  child: FloatingActionButton(
                    foregroundColor: Theme.of(context).focusColor,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      callBack();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 25.sp,
                      color: Theme.of(context).focusColor,
                    ),
                  )),
            ),
          )
        : Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 10.h,
                  width: 10.w,
                  child: FloatingActionButton(
                    foregroundColor: Theme.of(context).focusColor,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      callBack();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 20.sp,
                      color: Theme.of(context).focusColor,
                    ),
                  )),
            ),
          );
  }
}
