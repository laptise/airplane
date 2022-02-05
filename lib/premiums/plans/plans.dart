import 'dart:math';

import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/entities/plan.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../main.dart';
import 'add_new_plan.dart';

class Plans extends HookConsumerWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserDoc user = ref.watch(userInfoProvider) as UserDoc;
    final premInfo = user;
    return Scaffold(
      appBar: SlimAppBar("プラン管理"),
      body: Align(
        child: PlanBody(premInfo),
      ),
    );
  }
}

class PlanBody extends StatefulWidget {
  final UserDoc premInfo;
  const PlanBody(this.premInfo, {Key? key}) : super(key: key);

  @override
  State<PlanBody> createState() => _PlanBodyState();
}

class _PlanBodyState extends State<PlanBody> {
  bool isSearching = false;

  @override
  initState() {
    // 必ず、super.initState()を呼ぶこと
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            StreamBuilder(
                stream: Plan.getListStreamFromOwnerUid(widget.premInfo.id),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Plan>> snapShot) {
                  return SizedBox(
                    height: 400.0,
                    child: ListView(
                      children: snapShot.hasData
                          ? snapShot.data!.docs
                              .map((e) => SinglePlan(e))
                              .toList()
                          : [],
                    ),
                  );
                }),
          ],
        )
      ],
    );
  }
}

class SinglePlan extends StatelessWidget {
  final QueryDocumentSnapshot<Plan> snapshot;
  const SinglePlan(this.snapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Plan plan = snapshot.data();
    return ListTile(
      title: Text(plan.name),
      trailing: Text(plan.price.toString() + "円"),
      subtitle: Text(plan.note),
    );
  }
}
