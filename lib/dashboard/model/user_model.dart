class User {
  final String username;
  final String password;
  final String role; // "rep" or "finance"

  User({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() => {
        "username": username,
        "password": password,
        "role": role,
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map["username"] ?? "",
      password: map["password"] ?? "",
      role: map["role"] ?? "rep",
    );
  }
}