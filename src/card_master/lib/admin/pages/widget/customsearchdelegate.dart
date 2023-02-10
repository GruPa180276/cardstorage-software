import 'package:flutter/material.dart';

List<String> values = [];

class CustomSearchDelegate extends SearchDelegate {
  late Function setState;

  CustomSearchDelegate(Function state, List<String> searchValues) {
    setState = state;
    values = searchValues;
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
    for (var x in values) {
      if (x.toString().contains(query.toString())) {
        matchQuery.add(x);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin:
                      EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                  child: Column(children: [
                    Text(
                      result.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ]),
                ),
                onTap: () {
                  setState(matchQuery[index]);
                }));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var x in values) {
      if (x.toString().contains(query.toString())) {
        matchQuery.add(x);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin:
                      EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                  child: Column(children: [
                    Text(
                      result.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ]),
                ),
                onTap: () {
                  setState(matchQuery[index]);
                }));
      },
    );
  }
}
