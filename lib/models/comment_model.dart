// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

class CommentModel {
  String? uId;
  String? name;
  String? profileImage;
  String? date;
  String? text;

  CommentModel({
    this.uId,
    this.name,
    this.profileImage,
    this.date,
    this.text,
  });

  CommentModel.fromJson(Map<String, dynamic> comment) {
    uId = comment['uId'];
    name = comment['name'];
    profileImage = comment['profileImage'];
    date = comment['date'];
    text = comment['text'];
  }

  Map<String, dynamic> toMap() => {
        'uId': uId,
        'name': name,
        'profileImage': profileImage,
        'date': date,
        'text': text,
      };
}
