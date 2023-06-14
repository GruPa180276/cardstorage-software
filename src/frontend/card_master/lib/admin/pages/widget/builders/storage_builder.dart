import 'package:card_master/admin/provider/types/focus.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/storages.dart';
import 'package:card_master/admin/pages/widget/inkwells/storage_inkwell.dart';
import 'package:card_master/admin/pages/widget/generate/circularprogressindicator.dart';

class ListStorages extends StatefulWidget {
  final Future<List<Storages>> listOfStorages;
  final List<FocusS> listOfUnfocusedStorages;

  const ListStorages({
    Key? key,
    required this.listOfStorages,
    required this.listOfUnfocusedStorages,
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
                bool focusState = true;
                for (int i = 0;
                    i < widget.listOfUnfocusedStorages.length;
                    i++) {
                  if (widget.listOfUnfocusedStorages[i].name ==
                      data[index].name) {
                    focusState = false;
                  }
                }
                return GenerateStorage(
                  icon: Icons.storage,
                  route: "/alterStorage",
                  storage: data[index],
                  focusState: focusState,
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
