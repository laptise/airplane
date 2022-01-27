import 'package:flutter/material.dart';

class FindTop extends StatelessWidget {
  const FindTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
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
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                        height: deviceHeight * 1,
                        child: Container(
                            child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.amber),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [TextFormField()],
                              ),
                            )
                          ],
                        )));
                  });
            },
          ),
        )
      ],
    ));
  }
}
