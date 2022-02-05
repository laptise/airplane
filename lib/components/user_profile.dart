import 'package:airplane/entities/authInfo.dart';
import 'package:airplane/entities/plan.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:airplane/premiums/plans/plans.dart';
import 'package:airplane/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String toViewUid;
  const UserProfilePage(this.toViewUid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: UserDoc.getStreamFromUid(toViewUid),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<UserDoc>> snapshot) {
        return snapshot.hasData
            ? UserProfileBody(snapshot.data!.data()!)
            : const Text("js");
      },
    ));
  }
}

class UserProfileBody extends StatelessWidget {
  final UserDoc user;

  const UserProfileBody(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SlimAppBar(user.name),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                      color: Colors.black12, shape: BoxShape.circle),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                Text(
                  user.name,
                  style: TextPresets.bold16,
                ),
                UsersPlanList(user.id)
              ],
            ),
          ),
        ));
  }
}

class UsersPlanList extends StatelessWidget {
  final String premiumUserId;
  const UsersPlanList(this.premiumUserId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: const Text(
              "プラン一覧",
              style: TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder(
            stream: Plan.getListStreamFromOwnerUid(premiumUserId),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Plan>> snapshot) {
              return Column(
                children: snapshot.hasData
                    ? snapshot.data!.docs
                        .map((e) => SinglePlanPlate(e.data()))
                        .toList()
                    : [],
              );
            },
          ),
        ],
      ),
    );
  }
}

class SinglePlanPlate extends StatelessWidget {
  final Plan plan;

  const SinglePlanPlate(this.plan, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(plan.name),
            trailing: Text(plan.price.toString()),
            subtitle: Text(plan.note),
          ),
        ],
      ),
    );
  }
}
