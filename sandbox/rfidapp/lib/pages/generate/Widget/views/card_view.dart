// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/generate/widget/pup_up/reservate_popup.dart';

late var listOfTypes;
DateTime date = DateTime(2000, 1, 12, 12);
DateTime? vonTime;
DateTime? bisTime;

Widget cardsView(List<Cards> users, BuildContext context) => ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, index) {
      final user = users[index];
      Text title = Text(user.userId.toString());
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.card_giftcard_sharp, size: 30),
              ),
              Column(
                children: [
                  title,
                  Row(
                    children: [
                      ButtonBar(
                        children: [
                          FlatButton(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            shape: Border(
                                top: BorderSide(
                                    color: ColorSelect.greyBorderColor),
                                right: BorderSide(
                                    color: ColorSelect.greyBorderColor)),
                            color: Colors.transparent,
                            splashColor: Colors.black,
                            onPressed: () => buildReservatePopUp(context),
                            child: Text('Reservieren',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                          FlatButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              // NEW,
                              shape: Border(
                                  top: BorderSide(
                                      color: ColorSelect.greyBorderColor)),
                              //TODO ask if card is available and then ask if current time is not between reservated time
                              onPressed: () => print('tbc'),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxWidth: double.infinity),
                                child: Text('Jetzt holen',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ))
                        ],
                      )
                      //TODO chahnge to buttonbar
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
