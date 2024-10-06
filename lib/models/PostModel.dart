import 'package:socializeme_app/models/userData.dart';

class Postmodel {
  String title, description, time, userUid ;
  String? postId;
  String? imgLink;
  Userdata? user;
  Postmodel(
      {required this.title,
      required this.description,
      required this.time,
      required this.userUid,
      this.postId,
      this.imgLink,
      this.user});
  toJSON() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'imgLink': imgLink,
      'userUid': userUid
    };
  }
  factory Postmodel.json(Map<String, dynamic> json) {
    return Postmodel(
        postId: json['postId'],
        title: json['title'],
        description: json['description'],
        time: json['time'],
        imgLink: json['imgLink'],
        userUid: json['userUid']);
  }
}
