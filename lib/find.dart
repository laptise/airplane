import 'package:flutter/material.dart';

class FindTop extends StatelessWidget {
  const FindTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          child: Column(
            children: [
              const Text("プレミアムユーザーを探す"),
            ],
          ),
        )
      ],
    ));
  }
}
