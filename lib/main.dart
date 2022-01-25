import 'package:flutter/material.dart';
import 'chat.dart';
import 'find.dart';
import 'friends.dart';
import 'setting.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const Home(title: 'Fdr Demo Home Page'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

enum MegaMenu { friends, chat, find, setting }

class _HomeState extends State<Home> {
  MegaMenu _currentMegaMenu = MegaMenu.chat;

  void _setCurrentMega(int index) {
    setState(() {
      _currentMegaMenu = MegaMenu.values[index];
    });
  }

  Widget getTop() {
    switch (_currentMegaMenu) {
      case MegaMenu.friends:
        return FriendsTop();
      case MegaMenu.chat:
        return ChatTop();
      case MegaMenu.find:
        return FindTop();
      case MegaMenu.setting:
        return SetTop();
      default:
        throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        toolbarHeight: 30,
        title: const Text('aasse'),
        elevation: 0,
      ),
      body: getTop(),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.blue,
          currentIndex: _currentMegaMenu.index,
          onTap: (e) => _setCurrentMega(e),
          items: const [
            BottomNavigationBarItem(label: "友達", icon: Icon(Icons.people)),
            BottomNavigationBarItem(label: "チャット", icon: Icon(Icons.message)),
            BottomNavigationBarItem(label: "見つける", icon: Icon(Icons.search))
          ]),
    );
  }
}
