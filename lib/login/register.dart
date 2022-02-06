import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/http/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String _email = "";
  String _password = "";
  String _name = "";
  bool _agreed = false;
  final _form = GlobalKey<FormState>();

  void submit() async {
    try {
      await Req.registNewUser(_email, _password, _name, "hello");
      show();
    } catch (e) {
      print(e);
    }
  }

  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(content: Text("会員登録が完了しました。"));
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: "メールアドレス"),
                        initialValue: _email,
                        onChanged: (val) {
                          setState(() {
                            _email = val;
                          });
                        },
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            _password = val;
                          });
                        },
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "パスワード"),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            _name = val;
                          });
                        },
                        decoration: const InputDecoration(labelText: "名前"),
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
