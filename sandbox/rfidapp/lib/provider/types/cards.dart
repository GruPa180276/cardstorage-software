class Cards {
  final int userId;
  final int id;
  final String title;
  final String body;

  @override
  const Cards({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
  static Cards fromJson(json) => Cards(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );
}
