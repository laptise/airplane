import 'package:airplane/settings/payments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entities/authInfo.dart';
import '../main.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentSetting()),
                );
              },
              title: Row(children: const [Icon(Icons.payment), Text("支払い方法")]),
            ),
            ListTile(
              onTap: () async {
                ref.read(userInfoProvider.notifier).setInfo(null);
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
