// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

class UserModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  String? coverImage;
  String? bio;
  bool? isEmailVerified;

  UserModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.coverImage,
    this.bio,
    this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> user) {
    uId = user['uId'];
    name = user['name'];
    email = user['email'];
    phone = user['phone'];
    profileImage = user['profileImage'];
    coverImage = user['coverImage'];
    bio = user['bio'];
    isEmailVerified = user['isEmailVerified'];
  }

  Map<String, dynamic> toMap() => {
        'uId': uId,
        'name': name,
        'email': email,
        'phone': phone,
        'profileImage': profileImage,
        'coverImage': coverImage,
        'bio': bio,
        'isEmailVerified': isEmailVerified,
      };
}
