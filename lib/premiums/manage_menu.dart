import 'package:airplane/premiums/plans/plans.dart';
import 'package:airplane/setting.dart';
import 'package:flutter/material.dart';

class ManageTop extends StatelessWidget {
  const ManageTop({Key? key}) : super(key: key);

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
        body: Row(children: [
      buildBlock(context, Icons.manage_accounts, "プラン", (context) => Plans()),
      buildBlock(context, Icons.headphones, "道具２", (context) => const SetTop()),
      buildBlock(
          context, Icons.library_add, "道具３", (context) => const SetTop()),
      buildBlock(
          context, Icons.library_add, "道具３", (context) => const SetTop()),
    ]));
  }
}
