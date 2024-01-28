import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? password;
  final String fullName;
  final String email;

  const UserModel({
    this.id,
    this.password,
    required this.email,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Nome Completo": fullName,
      "E-mail": email,
    };
  }

  static UserModel empty() => const UserModel(
        id: '',
        email: '',
        fullName: '',
      );

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    
    if (data == null || data.isEmpty) {
      return UserModel.empty();
    }

    return UserModel(
      id: document.id,
      email: data["E-mail"] ?? '',
      fullName: data["Nome Completo"] ?? '',
    );
  }
}