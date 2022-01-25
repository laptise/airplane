import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsTop extends StatelessWidget {
  const FriendsTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.1, color: Color.fromRGBO(0, 0, 0, 0.8)))),
        padding: const EdgeInsets.all(8.0),
        child: Text(FirebaseAuth.instance.currentUser?.email ?? ""),
      )
    ]));
  }
}
