import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oasis/screens/auth/login_email.dart';
import 'package:oasis/screens/auth/login_home_page.dart';
import 'package:oasis/screens/auth/signup_email.dart';
import 'package:oasis/screens/chat/chat_page.dart';
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
      path: '/signup_email',
      builder: (BuildContext context, GoRouterState state) => const SignupEmail()
    ),
    GoRoute(
      path: '/post/:id',
      builder: (BuildContext context, GoRouterState state) {
        final int postId = int.parse(state.pathParameters['id']!);
        return PostDetailPage(postId: postId);
      }
    ),
    GoRoute(
      path: '/chat/:roomId',
      builder: (BuildContext context, GoRouterState state) {
        final String roomId = state.pathParameters['roomId'] as String;
        return ChatPage(roomId: roomId);
      }

    )
  ]
);

