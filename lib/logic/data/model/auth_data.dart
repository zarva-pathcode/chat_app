import 'dart:convert';

class AuthData {
  String? email;
  String? name;
  String? photoUrl;
  String? status;
  AuthData({
    this.email,
    this.name,
    this.photoUrl,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'status': status,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthData(email: $email, name: $name, photoUrl: $photoUrl, status: $status)';
  }
}
