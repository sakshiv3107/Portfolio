import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    // Deep-link redirects to scroll anchors handled in HomePage
    GoRoute(
      path: '/projects',
      redirect: (context, state) => '/',
    ),
    GoRoute(
      path: '/contact',
      redirect: (context, state) => '/',
    ),
  ],
);
