import 'package:admin_login/pages/widget/circularprogressindicator.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SelectStorage extends StatefulWidget {
  final Function callBack;

  SelectStorage({Key? key, required this.callBack}) : super(key: key);

  @override
  State<SelectStorage> createState() => _SelectStorageState();
}

class _SelectStorageState extends State<SelectStorage> {
  late Future<List<dynamic>> futureData;
  List<SpeedDialChild> dial = [
    SpeedDialChild(
      label: 'Test',
    )
  ];

  @override
  void initState() {
    super.initState();
    futureData = fetchData("cards", Cards);
  }

  @override
  Widget build(BuildContext context) {
    values(context);
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 28.0),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      foregroundColor: Theme.of(context).focusColor,
      visible: true,
      curve: Curves.bounceInOut,
      children: dial,
    );
  }

  Widget values(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                dial.add(SpeedDialChild(
                  child:
                      Icon(Icons.storage, color: Theme.of(context).focusColor),
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  onTap: () => widget.callBack(data![index].id.toString()),
                  label: data![index].id.toString(),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).focusColor),
                  labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
                ));
                return SizedBox.shrink();
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [generateProgressIndicator(context)],
        ));
      },
    );
  }
}
