import 'package:airplane/components/firebase.dart';
import 'package:airplane/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendsTop extends StatelessWidget {
  const FriendsTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: const [ProfileBadge()]));
  }
}

class ProfileBadge extends HookConsumerWidget {
  const ProfileBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthInfo userName = ref.watch(userInfoProvider) as AuthInfo;
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.1, color: Color.fromRGBO(0, 0, 0, 0.8)))),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName.userName ?? ""),
            Text(FirebaseAuth.instance.currentUser?.email ?? "")
          ],
        ));
  }
}
