import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socializeme_app/screens/ChatScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Cubits/ChatsProviderCubit/chats_procider_cubit.dart';
import '../../models/userData.dart';
import 'CustomProfileButtonIcons.dart';

class Otheruserprofilepagehead extends StatelessWidget {
  const Otheruserprofilepagehead({super.key, required this.currentUser});
  final Userdata currentUser;
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: currentUser.email,
      query: 'subject=Contact&body=ZUUU', // Add subject and body if needed
    );

    if (await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsProciderCubit(),
      child: Stack(
        children: [
          Positioned(
            child: Card(
                margin: const EdgeInsets.only(top: 55),
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
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BlocBuilder<ChatsProciderCubit, ChatsProciderState>(
                              builder: (context, state) {
                                if (state is ChatsProciderSearching) {
                                  return CircularProgressIndicator();
                                } else if (state is ChatsProciderFound) {
                                  // Instead of navigating here, you can set a flag
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pop(context);
                                    // Navigate only when the widget is fully built
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => Chatscreen(
                                              chatId: state
                                                  .ChatId, // Ensure this is correct
                                              User2:
                                                  currentUser)), // Update accordingly
                                    );
                                  });
                                  return Container(); // Return an empty container to prevent build errors
                                } else if (state is ChatsProciderCreating) {
                                  return CircularProgressIndicator();
                                } else if (state is ChatsProciderNotFound) {
                                  return CircularProgressIndicator();
                                } else if (state is ChatsProciderError) {
                                  return Text('Error');
                                }
                                return MessageButton(currentUser: currentUser);
                              },
                            ),
                            CustomProfileButtonIcons(
                              icondata: Icons.email_outlined,
                              onPressed: _sendEmail,
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
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(currentUser.imgLink),
                      fit: BoxFit.fitHeight)),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageButton extends StatelessWidget {
  const MessageButton({
    super.key,
    required this.currentUser,
  });

  final Userdata currentUser;

  @override
  Widget build(BuildContext context) {
    return CustomProfileButtonIcons(
      icondata: Icons.message_outlined,
      onPressed: () async {
        BlocProvider.of<ChatsProciderCubit>(context)
            .SearchChats(currentUser.uid);
      },
    );
  }
}
