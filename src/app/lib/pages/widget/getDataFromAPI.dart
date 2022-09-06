import 'package:flutter/material.dart';

import 'package:app/pages/widget/data.dart';
import 'package:app/pages/widget/card.dart';
import 'package:app/pages/widget/circularprogressindicator.dart';

class GetDataFromAPI extends StatefulWidget {
  final String cardStorage;
  final String route;

  GetDataFromAPI(
      {Key? key, required String this.route, required this.cardStorage})
      : super(key: key);

  @override
  State<GetDataFromAPI> createState() => _GetDataFromAPIState();
}

class _GetDataFromAPIState extends State<GetDataFromAPI> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.cardStorage == data![index].userId.toString()) {
                  return GenerateCards.withArguments(
                      index: index,
                      data: data,
                      icon: Icons.credit_card,
                      route: widget.route,
                      argument: data[index].id - 1);
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            child: Column(
          children: [generateProgressIndicator(context)],
        ));
      },
    ));
  }
}
