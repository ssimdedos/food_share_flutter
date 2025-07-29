import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/screens/login_email.dart';
import 'package:oasis/screens/login_home_page.dart';
import 'package:oasis/screens/post/post_detail_page.dart';
import 'package:oasis/widgets/bottom_navigation_bar.dart';

final GoRouter goRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const LoginHomePage()
    ),
    GoRoute(
      path: '/main',
      builder: (BuildContext context, GoRouterState state) => const IndexView()
    ),
    GoRoute(
      path: '/login_email',
      builder: (BuildContext context, GoRouterState state) => const LoginEmail()
    ),
    GoRoute(
      path: '/post/:id',
      builder: (BuildContext context, GoRouterState state) {
        final int postId = int.parse(state.pathParameters['id']!);
        return PostDetailPage(postId: postId);
      }
    )
  ]
);

