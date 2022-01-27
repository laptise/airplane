import 'package:flutter/material.dart';

import 'profileBadge.dart';

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
