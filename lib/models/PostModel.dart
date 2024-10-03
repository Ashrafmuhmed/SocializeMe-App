class Postmodel {
  String title, description, time, userUid;
  String? imgLink;
  Postmodel(
      {required this.title,
      required this.description,
      required this.time,
      required this.userUid,
      this.imgLink});
  toJSON() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'imgLink': imgLink,
      'userUid' : userUid
    };
  }
}
