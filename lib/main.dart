import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import './homescreen.dart';
import './orderscreen.dart';
import './shopscreen.dart';
import './inboxscreen.dart';


void main() async{
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LatinOne',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LatinOne'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  int inbox_flag = 0;

  void ChangeInboxFlag(int flag) {
    setState(() {
      inbox_flag = flag;
    });
  }

  void ChangeIndex(int index) {
    setState(() {
      inbox_flag = 0;
      currentPageIndex = index;
    });
  }

  late List<Widget> _screens;

  @override

  initState() {
    super.initState();
    _screens = [
      HomeScreen(ChangeIndex: ChangeIndex, ChangeInboxFlag: ChangeInboxFlag),
      OrderScreen(),
      ShopsScreen(),
      InboxScreen()
    ];
  }

  Widget build(BuildContext context) {


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if((inbox_flag == 1) | (currentPageIndex != 0)){
          setState(() {
            inbox_flag = 0;
            currentPageIndex = 0;
          });
        }
        else {
          SystemNavigator.pop();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: Colors.amber,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
              widget.title,
              style:
                TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          actions: <Widget>[
            IconButton(
              icon: Badge(
                child: Icon(Icons.notifications_outlined),
              ),
              tooltip: 'Inbox',
              onPressed: () {
                ChangeInboxFlag(inbox_flag);
              }
            ),
          ],
        ),
        // body: _screens[currentPageIndex],
        body: _ctr_screen(inbox_flag, currentPageIndex),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: ChangeIndex,
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.coffee),
              icon: Icon(Icons.coffee_outlined),
              label: 'Order',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.store),
              icon: Icon(Icons.store_outlined),
              label: 'Shops',
            ),
          ],
        ),
      ),
    );

  }

  Widget _ctr_screen(int inbox_flag, int index){
    if (inbox_flag == 1) {
      return InboxScreen();
    }else{
      return _screens[index];
    }
  }
}
