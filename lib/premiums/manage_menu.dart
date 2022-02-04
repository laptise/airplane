import 'package:airplane/channels/channels.dart';
import 'package:airplane/entities/plan.dart';
import 'package:airplane/premiums/plans/plans.dart';
import 'package:airplane/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class ManageTop extends StatelessWidget {
  const ManageTop({Key? key}) : super(key: key);
  Future<void> _getCamera() async {
// メソッドの呼び出し
    var result = await PaymentChannel.payTest();
    print(result);
  }

  Widget buildBlock(BuildContext context, IconData icon, String label,
      Widget Function(BuildContext) widget) {
    return Expanded(
      flex: 1,
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.black,
                side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                minimumSize: const Size(double.infinity, double.infinity)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget(context)),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(icon), Text(label)],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(children: [
          buildBlock(
              context, Icons.manage_accounts, "プラン", (context) => Plans()),
          buildBlock(
              context, Icons.headphones, "道具２", (context) => const SetTop()),
          buildBlock(
              context, Icons.library_add, "道具３", (context) => const SetTop()),
          buildBlock(
              context, Icons.library_add, "道具３", (context) => const SetTop()),
        ]),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CardField(
              onCardChanged: (card) {
                print(card);
              },
            )),
      ],
    ));
  }
}
