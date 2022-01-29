import 'package:airplane/find/findTopPremiumUser.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FindTop extends StatefulWidget {
  const FindTop({Key? key}) : super(key: key);

  @override
  State<FindTop> createState() => _FindTopState();
}

class _FindTopState extends State<FindTop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          child: TextButton(
            child: const Text(
              "プレミアムユーザーを探す",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindPremUser()),
              );
            },
          ),
        )
      ],
    ));
  }
}
