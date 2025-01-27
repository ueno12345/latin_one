import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './homescreen.dart';
import './orderscreen.dart';
import './shopscreen.dart';
import './inboxscreen.dart';

// GoRouter configuration
final goRouter = GoRouter(
  // screen when app start
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/Order',
      builder: (context, state) {
        final fcmToken = state.extra as String?;
        return OrderScreen(fcmToken: fcmToken);
      },
    ),
    GoRoute(
      path: '/Shops',
      builder: (context, state) => ShopsScreen(),
    ),
    GoRoute(
      path: '/Inbox',
      builder: (context, state) => InboxScreen(),
    ),
  ],
);