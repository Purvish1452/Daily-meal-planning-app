class User {
  final String id;
  final String username;
  final String email;
  final String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }
}
