// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final int phoneNo;
  final String email;
  final String password;

  UserModel({
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.password,
  });

  UserModel copyWith({
    String? name,
    int? phoneNo,
    String? email,
    String? password,
    String? department,
  }) {
    return UserModel(
      name: name ?? this.name,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNo': phoneNo,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      phoneNo: map['phoneNo'] as int,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, phoneNo: $phoneNo, email: $email, password: $password)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phoneNo == phoneNo &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        phoneNo.hashCode ^
        email.hashCode ^
        password.hashCode;
  }
}
