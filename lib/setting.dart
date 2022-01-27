import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main.dart';

class SetTop extends HookConsumerWidget {
  const SetTop({Key? key}) : super(key: key);

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              onTap: () async {
                ref.read(userInfoProvider.notifier).setInfo(AuthInfo());
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
