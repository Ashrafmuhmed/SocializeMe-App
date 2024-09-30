class Userdata {
  final String email, uid, username, bio;
  Userdata(
      {required this.bio,
      required this.email,
      required this.username,
      required this.uid});
  factory Userdata.json({required Map<String, dynamic> userData}) => Userdata(
      bio: userData['bio'],
      email: userData['email'],
      username: userData['username'],
      uid: userData['uid']);
  Map<String, dynamic> toJson() =>
      {'username': username, 'uid': uid, 'email': email, 'bio': bio};
}
