import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/constants/constants.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/screens/UserProfilePage.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _serach = TextEditingController();
  List allResults = [];
  List resultsList = [];
  List<Userdata> allUsers = [];
  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection(profiles)
        .orderBy('username')
        .get();
    setState(() {
      allResults = data.docs;
    });
    _onSearchChanged();
  }

  @override
  void initState() {
    // TODO: implement initState
    _serach.addListener(_onSearchChanged);

    super.initState();
  }

  searchResultList() {
    var showResults = [];
    if (_serach.text != '') {
      String name;
      for (var snapshot in allResults) {
        name = snapshot['username'].toString().toLowerCase();
        if (name.contains(_serach.text.toLowerCase())) {
          showResults.add(snapshot);
        }
      }
      setState(() {
        resultsList = showResults;
      });
    } else {
      setState(() {
        resultsList = [];
      });
      showResults = List.from(allResults);
    }
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _serach.removeListener(_onSearchChanged);
    _serach.dispose();
  }

  _onSearchChanged() {
    searchResultList();
    log(_serach.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          style: TextStyle(color: Colors.white),
          controller: _serach,
        ),
      ),
      body: ListView.builder(
          itemCount: resultsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Userprofilepage(userData: resultsList.elementAt(index)))),
              child: Card(
                  margin: EdgeInsets.only(top: 5),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/pics/WhatsApp Image 2024-09-25 at 17.05.31_61c35a2e.jpg'),
                                    fit: BoxFit.fitHeight)),
                          ),
                          subtitle: Text(
                            resultsList.elementAt(index)['bio'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 139, 139, 139)),
                          ),
                          title: Text(
                            resultsList.elementAt(index)['username'],
                            style: const TextStyle(
                                color: Colors.amber, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
