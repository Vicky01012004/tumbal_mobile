import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:obecity_projectsem4/login_screen.dart';
import 'package:obecity_projectsem4/page/Rekomendasipage.dart';
import 'splash_screen.dart';
import 'page/kalkulator.dart';
import 'page/statistik.dart';
import 'navigation/main_navigation.dart';
import 'beranda.dart';
import 'page/setting.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
  // runApp(const MyApp());
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
      locale: const Locale("id", "ID"),
      home: const LoginPage(),
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
