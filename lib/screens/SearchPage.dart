import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/constants/constants.dart';
import 'package:socializeme_app/models/userData.dart';

import '../widgets/SearchWidgets/UserTile.dart';

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
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
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
          style: const TextStyle(color: Colors.white),
          controller: _serach,
        ),
      ),
      body: ListView.builder(
          itemCount: resultsList.length,
          itemBuilder: (context, index) {
            return UserTile(userdata: (resultsList.elementAt(index) as QueryDocumentSnapshot).data() as Map<String, dynamic>);
          }),
    );
  }
}
