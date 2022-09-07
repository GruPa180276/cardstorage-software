import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';

List<String> values = [];
List<String> id = [];

class GenerateSearchField extends StatefulWidget {
  const GenerateSearchField({Key? key}) : super(key: key);

  @override
  State<GenerateSearchField> createState() => _GenerateSearchFieldState();
}

class _GenerateSearchFieldState extends State<GenerateSearchField> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    reloadCardList();
    values = [];
  }

  void reloadCardList() {
    setState(() {
      futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          addValues(data!);
          return Container();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return SizedBox.shrink();
      },
    );
  }

  void addValues(List<Data> data) {
    values.length = 0;
    for (int i = 0; i < data.length; i++) {
      values.add(data[i].title);
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
  late Function setState;

  CustomSearchDelegate(Function state) {
    setState = state;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in values) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(children: [
                Text(
                  result,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ]),
            ),
            onTap: () {
              setState(matchQuery[index]);
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in values) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(children: [
                Text(
                  result,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ]),
            ),
            onTap: () {
              setState(matchQuery[index]);
            });
      },
    );
  }
}
