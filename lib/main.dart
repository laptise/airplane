import 'package:airplane/firebase_options.dart';
import 'package:airplane/login/login.dart';
import 'package:airplane/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chat.dart';
import 'entities/authInfo.dart';
import 'find/top.dart';
import 'main/top.dart';

final userInfoProvider = StateNotifierProvider((ref) {
  return UserInfoSetter();
});

class UserInfoSetter extends StateNotifier<AuthInfo?> {
  UserInfoSetter() : super(null);
  void setInfo(AuthInfo? info) => state = info;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthInfo? user = ref.watch(userInfoProvider) as AuthInfo?;
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
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (user != null) {
                // User が null でなない、つまりサインイン済みのホーム画面へ
                return const Home(title: 'Fdr Demo Home Page');
              } else {
                return LoginPage();
              }
            })
        // User が null である、つまり未サインインのサインイン画面へ

        );
  }
}

final counterProvider = StateNotifierProvider((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  void increment() => state++;
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

enum MegaMenu { friends, chat, find }

class _HomeState extends State<Home> {
  MegaMenu _currentMegaMenu = MegaMenu.chat;

  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  void _setCurrentMega(int index) {
    setState(() {
      _currentMegaMenu = MegaMenu.values[index];
    });
  }

  Widget getTop() {
    switch (_currentMegaMenu) {
      case MegaMenu.friends:
        return const FriendsTop();
      case MegaMenu.chat:
        return const ChatTop();
      case MegaMenu.find:
        return const FindTop();
      default:
        throw Error();
    }
  }

  String getPageName() {
    switch (_currentMegaMenu) {
      case MegaMenu.friends:
        return "友達";
      case MegaMenu.chat:
        return "チャット";
      case MegaMenu.find:
        return "みつける";
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
      key: _scaffold,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 9,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: SizedBox(
          child: Text(
            getPageName(),
            textWidthBasis: TextWidthBasis.longestLine,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        toolbarHeight: 40,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetTop()),
              );
            },
          ),
        ],
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
