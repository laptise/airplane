import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/entities/plan.dart';
import 'package:airplane/entities/premiumUser.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main.dart';
import 'add_new_plan.dart';

class Plans extends HookConsumerWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthInfo user = ref.watch(userInfoProvider) as AuthInfo;
    final premInfo = user.premiumUserInfo;
    if (premInfo == null) throw Error();
    return Scaffold(
      appBar: SlimAppBar("プラン管理"),
      body: Align(
        child: PlanBody(premInfo),
      ),
    );
  }
}

class PlanBody extends StatefulWidget {
  final PremiumUser premInfo;
  const PlanBody(this.premInfo, {Key? key}) : super(key: key);

  @override
  State<PlanBody> createState() => _PlanBodyState();
}

class _PlanBodyState extends State<PlanBody> {
  bool isSearching = false;
  List<Plan> plans = [];
  Future<void> getPlans() async {
    final res = await widget.premInfo.getAllPlans();
    setState(() {
      plans = res;
    });
  }

  @override
  initState() {
    // 必ず、super.initState()を呼ぶこと
    super.initState();
    getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          child: const Text("wo?"),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "プラン一覧",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewPlan(widget.premInfo),
                        ));
                  },
                  child: const Text("新しいプランを追加する"),
                ),
              ],
            ),
            Text(isSearching ? "GOOD" : "BAD"),
            Column(
              children: plans.map((e) => Text(e.name)).toList(),
            )
          ],
        )
      ],
    );
  }
}
