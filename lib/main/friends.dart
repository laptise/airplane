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
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const ProfileBadge(),
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.05)),
        child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
            child: Text("友達リスト",
                style: TextStyle(
                  fontSize: 12,
                ))),
      )
    ]));
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
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                    height: 30,
                    width: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0.5,
                            primary: const Color.fromRGBO(255, 255, 255, 0.8),
                            side: const BorderSide(color: Colors.black26)),
                        child: const Text("編集",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        onPressed: () {}))),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.black12, shape: BoxShape.circle),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    userName.userName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(FirebaseAuth.instance.currentUser?.email ?? "")
                ])
              ],
            )
          ],
        ));
  }
}
