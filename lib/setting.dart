import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetTop extends StatelessWidget {
  const SetTop({Key? key}) : super(key: key);

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              onTap: () async {
                await logout();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              title: Row(children: const [Icon(Icons.logout), Text("ログアウト")]),
            )
          ],
        ),
      ),
    );
  }
}
