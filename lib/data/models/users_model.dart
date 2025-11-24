class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String token;

  final String? phone;
  final String? university;
  final String? city;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.token,
    this.phone,
    this.university,
    this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'] ?? 'N/A',
      image: json['image'],
      token: json['token'] ?? '',

      phone: json['phone'],
      university: json['university'],

      city: json['address'] is Map ? json['address']['city'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'token': token,
      'phone': phone,
      'university': university,
      'address': {'city': city},
    };
  }
}
