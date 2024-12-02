class User {
  final String name;
  final String phone;
  final String image;

  const User({
    required this.name,
    required this.phone,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
