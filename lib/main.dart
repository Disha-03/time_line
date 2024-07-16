import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timeline_demo/view/home/home_page.dart';
import 'package:timeline_demo/view/task_timer.dart';
import 'package:timeline_demo/view/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => TimerService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return GetMaterialApp(debugShowCheckedModeBanner: false,
          theme: darkTheme,
          home: const HomePage(),
        );
      },
    );
  }
}





