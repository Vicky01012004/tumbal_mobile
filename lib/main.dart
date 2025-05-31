import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obecity_projectsem4/login_screen.dart';
import 'package:obecity_projectsem4/page/Rekomendasipage.dart';
import 'splash_screen.dart';
import 'page/kalkulator.dart';
import 'page/statistik.dart';
import 'navigation/main_navigation.dart';
import 'beranda.dart';
import 'page/setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ObesCheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
      //   getPages: [
      //     GetPage(
      //         name: '/kalkulator',
      //         page: () => const MainNavigation(initialIndex: 0)),
      //     GetPage(
      //         name: '/statistik',
      //         page: () => const MainNavigation(initialIndex: 1)),
      //   ],
    );
  }
}
