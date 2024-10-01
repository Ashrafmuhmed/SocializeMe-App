import 'package:flutter/material.dart';
import 'package:socializeme_app/screens/DeleteAccountPage.dart';

import '../../models/userData.dart';
import 'CustomProfileButtonIcons.dart';

class UserProfilePageHead extends StatelessWidget {
  const UserProfilePageHead({super.key, required this.currentUser});
  final Userdata currentUser;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Card(
              margin: EdgeInsets.only(top: 55),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Column(
                  children: [
                    ListTile(
                      subtitle: Text(
                        currentUser.bio,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 139, 139, 139)),
                      ),
                      title: Text(
                        currentUser.username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 55),
                      child: Divider(
                        height: 10,
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomProfileButtonIcons(
                            icondata: Icons.delete_forever_outlined,
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm"),
                                      content: const Text(
                                          "Are you sure you want to delete your account?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeleteAccountPage()));
                                          },
                                          child: Text("Yes"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text("No"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                          CustomProfileButtonIcons(
                            icondata: Icons.edit,
                            onPressed: () {},
                          ),
                          CustomProfileButtonIcons(
                            icondata: Icons.add_circle_outline,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        Positioned(
          left: (MediaQuery.of(context).size.width - 100) / 2,
          top: 10,
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                        'assets/pics/WhatsApp Image 2024-09-25 at 17.05.31_61c35a2e.jpg'),
                    fit: BoxFit.fitHeight)),
          ),
        ),
      ],
    );
  }
}
