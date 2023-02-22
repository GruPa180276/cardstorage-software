import 'package:card_master/admin/pages/widget/circularprogressindicator.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/card/card_inkwell.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class ListCards extends StatefulWidget {
  final String selectedStorage;
  final Future<List<Storages>> listOfStorages;

  const ListCards({
    Key? key,
    required this.selectedStorage,
    required this.listOfStorages,
  }) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
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
                List<Cards>? cardsOfStorage = data[index].cards;
                String storageName = data[index].name;
                if (data[index].name == widget.selectedStorage) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: cardsOfStorage.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GenerateCard(
                          icon: Icons.credit_card,
                          route: "/alterCards",
                          card: cardsOfStorage[index],
                          storageName: storageName,
                        );
                      });
                } else if (widget.selectedStorage == "-") {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: cardsOfStorage.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GenerateCard(
                          icon: Icons.credit_card,
                          route: "/alterCards",
                          card: cardsOfStorage[index],
                          storageName: storageName,
                        );
                      });
                } else {
                  return const SizedBox.shrink();
                }
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
