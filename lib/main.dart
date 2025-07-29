import 'package:flutter/material.dart';
import 'package:oasis/providers/food_post_provider.dart';
import 'package:oasis/providers/theme_notifier.dart';
import 'package:oasis/utils/dio_client.dart';
import 'package:oasis/utils/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  // setupDioClient();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier(false)),
        ChangeNotifierProvider(create: (context) => FoodPostProvider())
      ],
      child: const OasisApp(),
    ),
  );
}

class OasisApp extends StatefulWidget {
  const OasisApp({super.key});

  @override
  State<OasisApp> createState() => _OasisAppState();
}

class _OasisAppState extends State<OasisApp> {

  @override
  Widget build(BuildContext context) {
  final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);
    return MaterialApp.router(
      title: 'Oasis',
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(163, 109, 59, 1.0)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo).copyWith(
          brightness: Brightness.dark,
          surface: const Color.fromRGBO(40, 40, 40, 1.0),
          onSurface: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      routerConfig: goRouter,
    );
  }
}