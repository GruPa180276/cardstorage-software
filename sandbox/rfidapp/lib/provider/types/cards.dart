class Cards {
  final int id;
  final String name;
  final int storageId;
  final bool isAvailable;

  @override
  const Cards({
    required this.id,
    required this.name,
    required this.storageId,
    required this.isAvailable,
  });
  static Cards fromJson(json) => Cards(
        id: json['id'],
        name: json['name'],
        storageId: json['storageId'],
        isAvailable: json['isAvailable'],
      );
}
