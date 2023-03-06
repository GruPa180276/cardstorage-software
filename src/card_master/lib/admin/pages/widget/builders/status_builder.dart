import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/inkwells/status_inkwell.dart';
import 'package:card_master/admin/pages/widget/generate/circularprogressindicator.dart';

class ListStatus extends StatefulWidget {
  final Future<List<Storages>> listOfStorages;

  const ListStatus({
    Key? key,
    required this.listOfStorages,
  }) : super(key: key);

  @override
  State<ListStatus> createState() => _ListStatusState();
}

class _ListStatusState extends State<ListStatus> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Storages>>(
      future: widget.listOfStorages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Storages>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                return GenerateStatus(
                  icon: Icons.credit_card,
                  route: "/status",
                  storage: data![index],
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Column(
          children: [
            Center(child: generateProgressIndicator(context)),
          ],
        );
      },
    ));
  }
}
