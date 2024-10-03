import 'package:socializeme_app/models/userData.dart';

class Postmodel {
  String title, description, time, userUid;
  String? imgLink;
  Userdata? user;
  Postmodel(
      {required this.title,
      required this.description,
      required this.time,
      required this.userUid,
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
}
