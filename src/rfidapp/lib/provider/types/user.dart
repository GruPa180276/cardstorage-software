class Users {
  final int userId;

  @override
  const Users({
    required this.userId,
  });

  Users fromJson(json) => Users(
        userId: json['userId'],
      );
}
