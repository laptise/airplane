import 'package:airplane/entities/plan.dart';
import 'package:airplane/entities/premiumUser.dart';
import 'package:airplane/find/find_top_premium_user.dart';
import 'package:flutter/material.dart';

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
    final newEntity = Plan(widget.premInfo.id, name, detail, int.parse(price));
    await Plan.makeNewPlan(newEntity);
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
                onPressed: () {
                  setNewPlan();
                },
                child: const Text("プラン登録"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
