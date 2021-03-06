import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:airplane/http/test.dart';
import 'package:airplane/main.dart';
import 'package:airplane/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentSetting extends HookConsumerWidget {
  const PaymentSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserDoc user = ref.watch(userInfoProvider) as UserDoc;
    final cardController = CardEditController();
    return Scaffold(
        appBar: SlimAppBar("支払い手段の設定"),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: user.getStripeInfo(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "カード番号の登録",
                        style: TextPresets.bold14,
                      ),
                      CardField(
                        controller: cardController,
                      ),
                      Text(
                        "請求者情報",
                        style: TextPresets.bold14,
                      ),
                      TextFormField(
                          decoration: const InputDecoration(labelText: "住所")),
                      TextButton(
                          onPressed: () {
                            user.updateCard(cardController.details);
                          },
                          child: Text("update"))
                    ],
                  );
                } else {
                  return Text("wait");
                }
              },
            )));
  }
}
