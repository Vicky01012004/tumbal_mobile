import 'package:flutter/material.dart';
import 'package:obecity_projectsem4/page/kalkulator.dart';
import 'package:obecity_projectsem4/page/statistik.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex; // Untuk menentukan tab yang aktif saat pertama kali dibuka
  const MainNavigation({Key? key, required this.initialIndex}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set tab awal berdasarkan parameter
  }

  // Fungsi untuk mengganti halaman saat tab berubah
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang ingin ditampilkan
    List<Widget> _pages = [
      IMTPage(),  // Halaman Kalkulator
      StatistikPage(),   // Halaman Statistik
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ObesCheck'),
      ),
      body: _pages[_currentIndex],  // Menampilkan halaman sesuai tab aktif
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
