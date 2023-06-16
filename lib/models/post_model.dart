// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

class PostModel {
  String? uId;
  String? name;
  String? profileImage;
  String? date;
  String? text;
  String? postImage;
  int? comments;
  List<String>? likes;

  PostModel({
    this.uId,
    this.name,
    this.profileImage,
    this.date,
    this.text,
    this.postImage,
    this.comments,
    this.likes,
  });

  PostModel.fromJson(Map<String, dynamic> post) {
    uId = post['uId'];
    name = post['name'];
    profileImage = post['profileImage'];
    date = post['date'];
    text = post['text'];
    postImage = post['postImage'];
    comments = post['comments'];
    likes = post['likes'].cast<String>();
  }

  Map<String, dynamic> toMap() => {
        'uId': uId,
        'name': name,
        'profileImage': profileImage,
        'date': date,
        'text': text,
        'postImage': postImage,
        'comments': comments,
        'likes': likes,
      };
}
