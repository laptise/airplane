import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("会員登録"),
        ),
        body: Form(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "メールアドレス",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, height: 2),
                  ),
                  TextField(
                    autocorrect: false,
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "パスワード",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, height: 2),
                  ),
                  TextField(
                    autocorrect: false,
                  ),
                ],
              ))
        ])));
  }
}
