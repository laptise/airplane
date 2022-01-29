import 'package:airplane/entities/premiumUser.dart';
import 'package:flutter/material.dart';

class FindPremUser extends StatefulWidget {
  const FindPremUser({Key? key}) : super(key: key);

  @override
  State<FindPremUser> createState() => _FindPremUserState();
}

class SlimAppBar extends AppBar {
  SlimAppBar(String title, {Key? key, double fontSize = 18.0})
      : super(
          key: key,
          toolbarHeight: 40,
          elevation: 0,
          title: SizedBox(
            child: Text(
              title,
              textWidthBasis: TextWidthBasis.longestLine,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            ),
          ),
        );
}

class _FindPremUserState extends State<FindPremUser> {
  List<PremiumUser> items = [];
  final _searchTextController = TextEditingController();
  Future<void> search() async {
    final val = _searchTextController.text.toLowerCase();
    final res = await PremiumUser.searchByName(val);
    setState(() {
      items = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SlimAppBar(
          'プレミアムユーザーを探す',
          fontSize: 16,
        ),
        body: Container(
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
                      },
                      controller: _searchTextController,
                      decoration: const InputDecoration(labelText: "検索キーワード"),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        var res = await search();
                      },
                      icon: const Icon(Icons.search_rounded))
                ],
              ),
              Expanded(
                child: SizedBox(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: items.map((e) => PremiumUserBadge(e)).toList(),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class PremiumUserBadge extends StatelessWidget {
  final PremiumUser sender;
  const PremiumUserBadge(this.sender, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Colors.black, style: BorderStyle.solid)),
        child: Text(sender.name));
  }
}
