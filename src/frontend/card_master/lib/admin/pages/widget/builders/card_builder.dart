import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/pages/widget/inkwells/card_inkwell.dart';
import 'package:card_master/admin/pages/widget/generate/circularprogressindicator.dart';

class ListCards extends StatefulWidget {
  final String selectedStorage;
  final Future<List<Cards>> listOfCards;

  const ListCards({
    Key? key,
    required this.selectedStorage,
    required this.listOfCards,
  }) : super(key: key);

  @override
  State<ListCards> createState() => _ListCardsState();
}

class _ListCardsState extends State<ListCards> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<List<Cards>>(
      future: widget.listOfCards,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
                if (data[index].storage == widget.selectedStorage) {
                  return GenerateCard(
                    icon: Icons.credit_card,
                    route: "/alterCards",
                    card: data[index],
                    storageName: data[index].storage,
                  );
                } else if (widget.selectedStorage == "-") {
                  return GenerateCard(
                    icon: Icons.credit_card,
                    route: "/alterCards",
                    card: data[index],
                    storageName: data[index].storage,
                  );
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
