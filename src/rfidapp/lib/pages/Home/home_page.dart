import 'package:flutter/material.dart';
import 'package:rfidapp/domain/local_notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocalNotificationService service;

  int selectedIndex = 0;
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 125,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text("Homepage",
                style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 40,
                    color: Theme.of(context).primaryColor))),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await service.showNotification(
                    id: 0, title: 'Notification Title', body: 'Some body');
              },
              child: const Text('Show Local Notification'),
            ),
            buildGetback(this.context),
          ],
        ));
  }

  Widget buildGetback(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Table(
          children: const [
            TableRow(
              children: [
                TableCell(child: Text("ID:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Name:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("StorageId:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Verfuegbar:")),
                TableCell(child: Text("ID:")),
              ],
            )
          ],
        ));
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {}
  }
}


// white, black, primary:, secondary: 