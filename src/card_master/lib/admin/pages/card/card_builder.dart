import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/card/card_inkwell.dart';
import 'package:card_master/admin/provider/types/storages.dart';

class ListCards extends StatefulWidget {
  final String selectedStorage;
  final List<Storages> listOfStorages;

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
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listOfStorages.length,
            itemBuilder: (BuildContext context, int index) {
              List<Cards>? cardsOfStorage = widget.listOfStorages[index].cards;
              String storageName = widget.listOfStorages[index].name;
              if (widget.listOfStorages[index].name == widget.selectedStorage) {
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
            }));
  }
}
