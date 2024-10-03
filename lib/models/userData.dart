class Userdata {
  final String email, uid, username, bio, imgLink;
  List<String>? posts;
  Userdata(
      {required this.bio,
      required this.email,
      required this.username,
      required this.uid,
      required this.imgLink});
  factory Userdata.json({required Map<String, dynamic> userData}) => Userdata(
      bio: userData['bio'],
      email: userData['email'],
      username: userData['username'],
      uid: userData['uid'],
      imgLink: userData['imgLink']
      );
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'imgLink': imgLink,
        'useruID' : uid,
        'postsIds': []
      };
}
