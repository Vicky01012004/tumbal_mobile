import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:obecity_projectsem4/page/beranda_ui.dart';
import 'package:obecity_projectsem4/page/setting.dart';
import 'package:obecity_projectsem4/page/Rekomendasipage.dart';
import 'dart:math';
import 'wigdets/custom_button.dart';
import 'page/kalkulator.dart';
import 'page/statistik.dart';

// Using the same custom button as other screens

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  double currentWeight = 60;
  List<double> weightHistory = [65, 60, 63, 58, 66, 59, 60, 60, 61];
  String bmiCategory = "Normal";
  String inputDate = "";
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  int currentPageIndex = 0;
  late Animation<double> _slideAnimation;

  // Konstanta warna untuk konsistensi dengan login dan splash screen
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Widget> pages = [
    RekomendasiPage(),
    StatistikPage(),
    BerandaUI(),
    IMTPage(),
    PengaturanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(color: Colors.white, Icons.recommend),
            icon: Icon(Icons.recommend_outlined),
            label: 'Rekomendasi',
          ),
          NavigationDestination(
            selectedIcon: Icon(color: Colors.white, Icons.bar_chart),
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Statistik',
          ),
          NavigationDestination(
            selectedIcon: Icon(color: Colors.white, Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            selectedIcon: Icon(color: Colors.white, Icons.calculate),
            icon: Icon(Icons.calculate_outlined),
            label: 'IMT',
          ),
          NavigationDestination(
            selectedIcon: Icon(color: Colors.white, Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),

      // backgroundColor: Colors.green,
      //   onDestinationSelected: (int index) {
      //     setState(() {
      //       currentPageIndex = index;
      //     });
      //   },
      //   indicatorColor: Colors.green,
      //   selectedIndex: currentPageIndex,

      //   destinations: const <Widget>[
      //     NavigationDestination(
      //       selectedIcon:  Icon(color: Colors.white,Icons.recommend),
      //       icon:  Icon(Icons.recommend_outlined),
      //       label: 'Rekomendasi',
      //     ),
      //     NavigationDestination(
      //       selectedIcon:   Icon(color: Colors.white, Icons.bar_chart),
      //       icon:   Icon(Icons.bar_chart_outlined),
      //       label: 'Statistik',
      //     ),
      //     NavigationDestination(
      //       selectedIcon:  Icon(color: Colors.white,Icons.home),
      //       icon:   Icon(Icons.home_outlined),
      //       label: 'Beranda',
      //     ),
      //     NavigationDestination(
      //       selectedIcon:   Icon(color: Colors.white, Icons.calculate),
      //       icon:    Icon(Icons.calculate_outlined),
      //       label: 'IMT',
      //     ),
      //     NavigationDestination(
      //       selectedIcon:  Icon(color: Colors.white,Icons.settings),
      //       icon:   Icon(Icons.settings_outlined),
      //       label: 'Pengaturan',
      //     ),

      //   ],
      // ),
      // BottomNavigationBar(
      //   backgroundColor: Colors.red,
      //   selectedItemColor: Colors.amber[800],
      //   currentIndex: 1,
      //   onTap: (index) {
      //     if (index == 0) {
      //       // Navigasi ke Rekomendasi
      //     } else if (index == 1) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => StatistikPage()),
      //       );
      //     }
      //     // Tambahkan navigasi ke tab lain sesuai kebutuhan
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.recommend), label: 'Rekomendasi'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.bar_chart), label: 'Statistik'),
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
      //     BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'IMT'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings), label: 'Pengaturan'),
      //   ],
      // ),
    );
  }
}
