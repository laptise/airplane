import 'package:airplane/components/alert.dart';
import 'package:airplane/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class LoginPage extends HookConsumerWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String get email => emailController.text;
  String get password => passwordController.text;

  Future<void> submit(BuildContext context, WidgetRef ref) async {
    var auth = FirebaseAuth.instance;
    try {
      ref.read(userInfoProvider.notifier).setInfo(LoginUserInfo("da"));
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      SimpleAlert.showMessage((context), "ログインに失敗しました。");
      print(e);
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

class _SigninPageState extends State<SigninPage> {
  String _email = "";
  String _password = "";
  bool _agreed = false;
  final _form = GlobalKey<FormState>();

  void updateEmail(String value) {
    setState(() {
      _email = value;
    });
  }

  void updatePassword(String value) {
    setState(() {
      _password = value;
    });
  }

  void submit() async {
    var auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      show();
    } catch (e) {
      print(e);
    }
    print(_email);
    print(_password);
  }

  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("会員登録が完了しました。"),
          children: <Widget>[
            // コンテンツ領域
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Text("１項目目"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("会員登録"),
        ),
        body: Form(
            key: _form,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "メールアドレス"),
                        initialValue: _email,
                        onChanged: updateEmail,
                      ),
                      TextFormField(
                        onChanged: updatePassword,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "パスワード"),
                      ),
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              _agreed = !_agreed;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: _agreed,
                                  onChanged: (checked) => {
                                        setState(() => {
                                              if (checked != null)
                                                _agreed = checked
                                            })
                                      }),
                              const Text("会員規約に同意しました。")
                            ],
                          )),
                      ElevatedButton(
                          onPressed: submit, child: const Text("会員登録"))
                      // FloatingActionButton.large(onPressed: ()=>_form.currentState.sub)
                    ],
                  )),
            ])));
  }
}
