class Users {
  final int userId;

  const Users({
    required this.userId,
  });

  Users fromJson(json) => Users(
        userId: json['userId'],
      );
}
