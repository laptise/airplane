import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/entities/plan.dart';
import 'package:airplane/entities/premiumUser.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';

class Plans extends HookConsumerWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthInfo user = ref.watch(userInfoProvider) as AuthInfo;
    final premInfo = user.premiumUserInfo;
    if (premInfo == null) throw Error();
    return Scaffold(appBar: SlimAppBar("プラン管理"), body: PlanBody(premInfo));
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          child: const Text("wo?"),
        ),
        Text(isSearching ? "GOOD" : "BAD")
      ],
    );
  }
}
