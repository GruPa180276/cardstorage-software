import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/storage/storage_inkwell.dart';
import 'package:card_master/admin/pages/widget/circularprogressindicator.dart';

class ListStorages extends StatefulWidget {
  final Future<List<Storages>> listOfStorages;
  final bool focusState;

  const ListStorages({
    Key? key,
    required this.listOfStorages,
    required this.focusState,
  }) : super(key: key);

  @override
  State<ListStorages> createState() => _ListStoragesState();
}

class _ListStoragesState extends State<ListStorages> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Storages>>(
      future: widget.listOfStorages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Storages>? data = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
                return GenerateStorage(
                  icon: Icons.storage,
                  route: "/alterStorage",
                  storage: data[index],
                  focusState: widget.focusState,
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
