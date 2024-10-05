import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/screens/CurrentUserProfileScreen.dart';
import 'package:socializeme_app/screens/PostsScreen.dart';
import 'package:socializeme_app/screens/SearchPage.dart';

class Mainscreen extends StatefulWidget {
    static final String id = 'MainScreen';

  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _selectedIndex = 0;

  // List of widgets to navigate between
  static final List<Widget> _pages = <Widget>[
    const Postsscreen(),
    SearchPage(),
    const Profilescreen(),
    const Center(child: Text('More Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
