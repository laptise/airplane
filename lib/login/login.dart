import 'package:airplane/components/alert.dart';
import 'package:airplane/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entities/authInfo.dart';
import '../entities/instance.dart';
import 'register.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String get email => emailController.text;
  String get password => passwordController.text;

  Future<void> submit(BuildContext context, WidgetRef ref) async {
    var auth = FirebaseAuth.instance;
    try {
      final userRef = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final uid = userRef.user!.uid;
      final userInfo = await UserDoc.getFromUid(uid);
      ref.read(userInfoProvider.notifier).setInfo(userInfo);
    } catch (e) {
      SimpleAlert.showMessage((context), "ログインに失敗しました。");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "メールアドレス"),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "パスワード"),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await submit(context, ref);
                          },
                          child: const Text("ログイン")),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20)),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SigninPage()),
                            );
                          },
                          child: const Text("会員登録"))
                    ],
                  )
                  // FloatingActionButton.large(onPressed: ()=>_form.currentState.sub)
                ],
              )),
        ])));
  }
}
