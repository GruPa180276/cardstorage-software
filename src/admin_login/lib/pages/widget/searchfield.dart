import 'package:admin_login/pages/widget/data.dart';
import 'package:flutter/material.dart';

List<String> values = [];

class GenerateSearchValues extends StatefulWidget {
  final Function setValue;

  GenerateSearchValues({Key? key, required this.setValue}) : super(key: key);

  @override
  State<GenerateSearchValues> createState() => _GenerateSearchValuesState();
}

class _GenerateSearchValuesState extends State<GenerateSearchValues> {
  late Future<List<Data>> futureData;

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
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          addValues(data!);
          return SizedBox();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return SizedBox.shrink();
      },
    );
  }

  void addValues(List<Data> data) {
    values.length = 0;
    for (int i = 0; i < data.length; i++) {
      widget.setValue(data[i].title);
    }
  }
}
