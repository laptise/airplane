import 'package:airplane/firebase_options.dart';
import 'package:airplane/login/login.dart';
import 'package:airplane/premiums/manage_menu.dart';
import 'package:airplane/settings/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'chat.dart';
import 'entities/authInfo.dart';
import 'find/top.dart';
import 'main/top.dart';

final userInfoProvider = StateNotifierProvider((ref) {
  return UserInfoSetter();
});

class UserInfoSetter extends StateNotifier<UserDoc?> {
  UserInfoSetter() : super(null);
  void setInfo(UserDoc? info) => state = info;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51KOaKzE4EGeaPqNZuE4ZkutgBjt51Iv4GSExJmGfEzDO3M7njDWtnIicWwfBjTqeO6UoT8WpjKhRq2PJLeZczarv006mGwNEOE";
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
    final UserDoc? user = ref.watch(userInfoProvider) as UserDoc?;
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
                return Home(user: user);
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
  final UserDoc user;
  const Home({Key? key, required this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        return widget.user.isPremium ? ManageTop() : const FindTop();
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
        return widget.user.isPremium ? "管理メニュー" : "みつける";
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
          items: [
            BottomNavigationBarItem(
                label: widget.user.isPremium ? "登録者" : "友達",
                icon: const Icon(Icons.people)),
            const BottomNavigationBarItem(
                label: "チャット", icon: Icon(Icons.message)),
            widget.user.isPremium
                ? const BottomNavigationBarItem(
                    label: "管理", icon: Icon(Icons.manage_accounts))
                : const BottomNavigationBarItem(
                    label: "見つける", icon: Icon(Icons.search))
          ]),
    );
  }
}
