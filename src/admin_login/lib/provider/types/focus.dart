import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

class FocusS {
  String name;

  FocusS({
    required this.name,
  });

  factory FocusS.fromJson(dynamic json) {
    return FocusS(
      name: json ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

Future<List<FocusS>> getAllUnfocusedStorages() async {
  final response = await http.get(
    Uri.parse(adres.storageAdress + "/focus"),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => FocusS.fromJson(data)).toList();
  } else {
    throw Exception('Failed to get Storages!');
  }
}
