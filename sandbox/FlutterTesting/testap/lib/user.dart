class User {
  final int userId;
  final int id;
  final String title;
  final String body;

  const User({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  static User fromJson(json) => User(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );
}
