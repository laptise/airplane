import 'package:flutter/material.dart';

class ManageTop extends StatelessWidget {
  const ManageTop({Key? key}) : super(key: key);

  Widget buildBlock(BuildContext context, IconData icon, String label) {
    return Expanded(
      flex: 1,
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon), Text(label)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      buildBlock(context, Icons.manage_accounts, "道具１"),
      buildBlock(context, Icons.headphones, "道具２"),
      buildBlock(context, Icons.library_add, "道具３"),
    ]));
  }
}
