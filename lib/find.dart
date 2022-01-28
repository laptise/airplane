import 'package:airplane/components/firebase.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FindTop extends StatefulWidget {
  const FindTop({Key? key}) : super(key: key);

  @override
  State<FindTop> createState() => _FindTopState();
}

class _FindTopState extends State<FindTop> {
  List<Sender> items = [];
  final _searchTextController = TextEditingController();
  Future<List<Sender>> search() async {
    final val = _searchTextController.text;
    final res = await FsRefs.senderColRef
        .where("name", isGreaterThanOrEqualTo: val)
        .where("name", isLessThan: val + "z")
        .get();

    final docs = res.docs.map((x) => x.data()).toList();
    return docs.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          child: TextButton(
            child: const Text(
              "プレミアムユーザーを探す",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              setState(() {
                items = [];
              });
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return SizedBox(
                          child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration:
                                const BoxDecoration(color: Colors.amber),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('ユーザーを検索',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  )),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        onFieldSubmitted: (val) async {
                                          var res = await search();
                                          setState(() {
                                            items = res;
                                          });
                                        },
                                        controller: _searchTextController,
                                        decoration: const InputDecoration(
                                            labelText: "検索キーワード"),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          var res = await search();
                                          setState(() {
                                            items = res;
                                          });
                                        },
                                        icon: const Icon(Icons.search_rounded))
                                  ],
                                ),
                                SizedBox(
                                  height: 200.0,
                                  child: ListView(
                                    children: items
                                        .map((e) => PUserBadge(e))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ));
                    });
                  });
            },
          ),
        )
      ],
    ));
  }
}

class PUserBadge extends StatelessWidget {
  final Sender sender;
  const PUserBadge(this.sender, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Colors.black, style: BorderStyle.solid)),
        child: Text(sender.name));
  }
}
