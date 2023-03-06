import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/inkwells/user_inkwell.dart';

class ListUsers extends StatefulWidget {
  final List<Users> listOfUsers;

  const ListUsers({
    Key? key,
    required this.listOfUsers,
  }) : super(key: key);

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.listOfUsers.length,
            itemBuilder: (context, index) {
              return GenerateUser(
                icon: Icons.storage,
                user: widget.listOfUsers[index],
              );
            }));
  }
}
