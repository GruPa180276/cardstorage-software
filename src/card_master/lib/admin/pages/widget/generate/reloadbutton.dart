import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GenerateReloadButton extends StatelessWidget {
  final Function callBack;

  const GenerateReloadButton({
    Key? key,
    required this.callBack,
  }) : super(key: key);

  @override
  Align build(BuildContext context) {
    return SizerUtil.deviceType == DeviceType.mobile
        ? Align(
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
          )
        : Align(
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
          );
  }
}
