import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:rfidapp/pages/generate/widget/createCardButton.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/pages/generate/pop_up/reservate_popup.dart';
import 'package:rfidapp/domain/app_preferences.dart';

Widget cardsView(List<Cards> cards, BuildContext context, String site,
        Set<String> pinnedCards, Function reloadPinned, String searchstring) =>
    Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            bool card = false;

            if (site == 'favoriten') {
              if (pinnedCards.isEmpty && index == cards.length - 1) {
                return Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 2 - 200,
                        horizontal: 0),
                    child: Text(
                      'Sie haben keine Favoriten ;)',
                      style: TextStyle(
                          color: Theme.of(context).dividerColor, fontSize: 20),
                    ),
                  ),
                );
              }
              for (String id in pinnedCards) {
                card = cards[index].id.toString().contains(id);
                if (card) {
                  break;
                }
              }
            } else {
              card = cards[index].name!.contains(searchstring);
            }
            return card
                ? Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(children: [
                      Row(children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 30, 0),
                          child: Icon(Icons.credit_card_outlined, size: 35),
                        ),
                        buildCardsText(context, cards[index], site, pinnedCards,
                            reloadPinned),
                      ]),
                      buildBottomButton(context, site, cards[index])
                    ]))
                : Container();
          }),
    );

Widget buildCardsText(BuildContext context, Cards card, String site,
    Set<String> pinnedCards, Function reloadPinned) {
  bool isFavorised = false;

  Color colorPin = Theme.of(context).primaryColor;
  Color colorAvailable = Colors.green;
  if (pinnedCards.contains(card.id.toString())) {
    colorPin = Colors.yellow;
    isFavorised = true;
  }

  Widget favoriteButton = IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.podcasts,
        color: Theme.of(context).cardColor,
      ));

  Widget emailButton = IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.podcasts,
        color: Theme.of(context).cardColor,
      ));

  if (!card.isAvailable!) {
    colorAvailable = Colors.red;
  }

  if (site == "cards" || site == "favoriten") {
    if (!card.isAvailable!) {
      emailButton = Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width - 171, 55, 0, 0),
          child: IconButton(
              onPressed: () async {
                // Android: Will open mail app or show native picker.
                // iOS: Will open mail app if single mail app found.

                var result = await OpenMailApp.composeNewEmailInMailApp(
                  emailContent: EmailContent(
                      cc: List.filled(1, "grubauer.patrick@gmail.com"),
                      body: "asd",
                      bcc: List.filled(1, "grubauer.patrick@gmail.com"),
                      to: List.filled(1, "grubauer.patrick@gmail.com"),
                      subject: "asdads"),
                );

                // If no mail apps found, show error
                if (!result.didOpen && !result.canOpen) {
                  showNoMailAppsDialog(context);

                  // iOS: if multiple mail apps found, show dialog to select.
                  // There is no native intent/default app system in iOS so
                  // you have to do it yourself.
                } else if (!result.didOpen && result.canOpen) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return MailAppPickerDialog(
                        mailApps: result.options,
                      );
                    },
                  );
                }
              },
              icon: Icon(Icons.email)));
    }

    favoriteButton = StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return IconButton(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width - 160, 0, 0, 0),
          onPressed: () {
            setState(
              () {
                isFavorised = !isFavorised;
                if (isFavorised) {
                  colorPin = Colors.yellow;
                  AppPreferences.addCardPinned(card.id.toString());
                } else {
                  colorPin = Theme.of(context).primaryColor;
                  AppPreferences.removePinnedCardAt(card.id);
                  pinnedCards = AppPreferences.getCardsPinned();
                  reloadPinned();
                }
              },
            );
          },
          splashColor: Colors.transparent,
          splashRadius: 0.1,
          icon: Icon(
            Icons.star,
            color: colorPin,
          ));
    });
  }

  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: Table(
          //border: TableBorder.all(),

          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(150),
            1: FixedColumnWidth(100),
          },

          children: [
            TableRow(
              children: [
                const TableCell(child: Text("ID:")),
                TableCell(child: Text(card.id.toString()))
              ],
            ),
            TableRow(
              children: [
                const TableCell(child: Text("Name:")),
                TableCell(child: Text(card.name.toString()))
              ],
            ),
            TableRow(
              children: [
                const TableCell(child: Text("StorageId:")),
                TableCell(child: Text(card.storageId.toString()))
              ],
            ),
            TableRow(
              children: [
                const TableCell(child: Text("Verfuegbar:")),
                TableCell(
                  child: Text(
                    card.isAvailable.toString(),
                    style: TextStyle(
                        color: colorAvailable, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      favoriteButton,
      emailButton
    ],
  );
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}

Widget buildBottomButton(BuildContext context, String site, Cards card) {
  switch (site) {
    case 'reservation':
      return Row(
        children: [
          Expanded(
            child: CardButton(
                text: 'Löschen',
                onPress: () {
                  card.isReserved = false;
                  Data.putData("card", card.toJson());
                  (context as Element).reassemble();
                }),
          ),
          Expanded(
              child: CardButton(
                  text: 'Bearbeiten',
                  onPress: () => buildReservatePopUp(context, card)))
        ],
      );
    case 'favoriten':
    case 'cards':
      Widget getNow = const SizedBox(
        width: 0,
        height: 0,
      );
      if (!card.isAvailable!) {
        return Row(
          children: [
            Expanded(
              child: CardButton(
                  text: 'Jetzt holen',
                  onPress: () => buildReservatePopUp(context, card)),
            ),
            SizedBox(
              width: 1,
              height: 50,
              child: Container(
                color: Theme.of(context).dividerColor,
              ),
            ),
            Expanded(
                child: CardButton(
                    text: 'Erinnere mich',
                    onPress: () => buildReservatePopUp(context, card)))
          ],
        );
      }
      return Stack(
        children: [
          Row(
            children: <Widget>[
              getNow,
              Expanded(
                  child: CardButton(
                      text: 'Reservieren',
                      onPress: () => buildReservatePopUp(context, card))),
            ],
          ),
        ],
      );
  }
  return const Text('error');
}
