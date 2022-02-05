import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String toViewUid;
  const UserProfilePage(this.toViewUid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: UserDoc.getStreamFromUid(toViewUid),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<UserDoc>> snapshot) {
        return snapshot.hasData
            ? UserProfileBody(snapshot.data!.data()!)
            : const Text("js");
      },
    ));
  }
}

class UserProfileBody extends StatelessWidget {
  final UserDoc user;

  const UserProfileBody(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SlimAppBar(user.name),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [Text(user.note)],
            ),
          ),
        ));
  }
}
