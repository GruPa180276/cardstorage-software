import 'package:admin_login/pages/widget/cards.dart';
import 'package:flutter/material.dart';

List<int> values = [];

class GenerateSearchValues extends StatefulWidget {
  final Function setValue;

  GenerateSearchValues({Key? key, required this.setValue}) : super(key: key);

  @override
  State<GenerateSearchValues> createState() => _GenerateSearchValuesState();
}

class _GenerateSearchValuesState extends State<GenerateSearchValues> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    values = [];
  }

  void reloadCardList() {
    setState(() {
      futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic>? data = snapshot.data;
          addValues(data!);
          return SizedBox();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return SizedBox.shrink();
      },
    );
  }

  void addValues(List<dynamic> data) {
    values.length = 0;
    for (int i = 0; i < data.length; i++) {
      widget.setValue(data[i].id);
    }
  }
}
