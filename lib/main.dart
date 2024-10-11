import 'dart:developer' as developer;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './firebase_options.dart';
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

  final messagingInstance = FirebaseMessaging.instance;
  messagingInstance.requestPermission();

  final fcmToken = await messagingInstance.getToken();
  debugPrint('FCM TOKEN: $fcmToken');

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if (Platform.isAndroid) {
    final androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_notification_channel',
        'プッシュ通知のチャンネル名',
        importance: Importance.max,
      ),
    );
    await androidImplementation?.requestNotificationsPermission();
  }

  // 通知設定の初期化を行う
  _initNotification();

  // アプリ停止時に通知をタップした場合はgetInitialMessageでメッセージデータを取得できる
  final message = await FirebaseMessaging.instance.getInitialMessage();
  // 取得したmessageを利用した処理などを記載する

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LatinOne'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
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

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ネットワーク接続がありません'),
          content: Text('ネットワーク接続を確認してください'),
          actions: <Widget>[
            TextButton(
              child: Text('戻る'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  late List<Widget> _screens;

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(ChangeIndex: ChangeIndex, ChangeInboxFlag: ChangeInboxFlag),
      OrderScreen(),
      ShopsScreen(),
      InboxScreen()
    ];

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });

    if(_connectionStatus[0] == ConnectivityResult.none) {
      _showNoConnectionDialog();
    }
  }

  Widget build(BuildContext context) {
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
          backgroundColor: Colors.amber,
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

Future<void> _initNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // バックグラウンド起動中に通知をタップした場合の処理
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    // フォアグラウンド起動中に通知が来た場合の処理

    // フォアグラウンド起動中に通知が来た場合、
    // Androidは通知が表示されないため、ローカル通知として表示する
    // https://firebase.flutter.dev/docs/messaging/notifications#application-in-foreground
    if (Platform.isAndroid) {
      // プッシュ通知をローカルから表示する
      await FlutterLocalNotificationsPlugin().show(
        0,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_notification_channel',
            'プッシュ通知のチャンネル名',
            importance: Importance.max, // 通知の重要度の設定
            icon: android?.smallIcon,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  });

  // ローカルから表示したプッシュ通知をタップした場合の処理を設定
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings(
          '@mipmap/ic_launcher'), //通知アイコンの設定は適宜行ってください
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        final payloadMap =
        json.decode(details.payload!) as Map<String, dynamic>;
        debugPrint(payloadMap.toString());
      }
    },
  );
}
