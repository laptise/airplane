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
          ],
        )
      ],
    );
  }
}

class AddNewPlan extends StatefulWidget {
  final PremiumUser premInfo;
  const AddNewPlan(this.premInfo, {Key? key}) : super(key: key);

  @override
  State<AddNewPlan> createState() => _AddNewPlanState();
}

class _AddNewPlanState extends State<AddNewPlan> {
  final nameController = TextEditingController();
  final planDetailController = TextEditingController();
  final priceController = TextEditingController();

  Future<void> setNewPlan() async {
    final name = nameController.text;
    final detail = planDetailController.text;
    final price = priceController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SlimAppBar("プラン追加"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "プラン名"),
              ),
              TextFormField(
                controller: planDetailController,
                decoration: const InputDecoration(labelText: "プラン説明"),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "料金 : (１月あたり)"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("プラン登録"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
