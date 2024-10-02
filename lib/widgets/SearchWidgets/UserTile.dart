import 'package:flutter/material.dart';
import 'package:socializeme_app/models/userData.dart';

import '../../screens/UserProfilePage.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.userdata,
  });

  final Map<String , dynamic> userdata;
  @override
  Widget build(BuildContext context) {
    Userdata user = Userdata.json(userData: userdata);
    return Card(
      
        margin: const EdgeInsets.only(top: 5),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              ListTile(
                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Userprofilepage(
            user: user))),
                leading: Container(
                  width: 100,
                  height: 100,
                  decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(user.imgLink),
                          fit: BoxFit.fitHeight)),
                ),
                subtitle: Text(
                  user.bio,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 139, 139, 139)),
                ),
                title: Text(
                  user.username,
                  style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ));
  }
}
