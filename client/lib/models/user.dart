class User {
  final int id;
  final String username;
  final String password;
  final String image;

  User({required this.id, required this.username, required this.password, required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'image': image,
    };
  }
}
