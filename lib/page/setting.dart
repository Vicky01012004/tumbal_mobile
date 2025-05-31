import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obecity_projectsem4/login_screen.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  _PengaturanPageState createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  String nama = '';
  int currentPageIndex = 4;

  // Konstanta warna untuk konsistensi dengan beranda page
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  @override
  void initState() {
    getUserLogin();
    super.initState();
    // Initialize animations consistent with beranda page
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void getUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("nama"));
    setState(() {
      nama = prefs.getString("nama")!;
      // userEmail = prefs.getString("email")!;
    });
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
              SizedBox(width: 10),
              Text('Atur Ulang Aplikasi'),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin mengatur ulang aplikasi? Semua data berat badan dan preferensi Anda akan dihapus.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Atur Ulang'),
              onPressed: () {
                // Implement reset functionality here
                Navigator.of(context).pop();
                // Show confirmation snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Aplikasi telah diatur ulang'),
                    backgroundColor: primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 10),
              Text('Keluar dari Aplikasi'),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Keluar'),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                // Implement logout functionality here
                // Navigator.of(context).pop();
                prefs.remove('token');
                Get.offAll(() => LoginPage());
                // Add navigation to login screen or app exit
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor1,
              backgroundColor2,
              backgroundColor3,
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeInAnimation.value,
                child: child,
              ),
            );
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header with title
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.settings,
                          color: primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Card
                  _buildGlassCard(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor,
                          child:
                              Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          nama,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Aktif',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Pribadi Card
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Info Pribadi",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                            icon: Icons.cake,
                            label: "Tanggal Lahir",
                            value: "30 April 2000"),
                        _buildInfoRow(
                            icon: Icons.height,
                            label: "Tinggi Badan",
                            value: "175 cm"),
                        _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: "Dibuat Sejak",
                            value: "17 Agustus 1945"),
                        _buildInfoRow(
                            icon: Icons.person_2,
                            label: "Jenis Kelamin",
                            value: "Pria"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Settings Card
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tune,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Lainnya",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Reset Button
                        GestureDetector(
                          onTap: _showResetConfirmationDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.restore,
                                        color: Colors.orange[700]),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Atur Ulang Aplikasi',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.orange[700]),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Logout Button
                        GestureDetector(
                          onTap: _showLogoutConfirmationDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.logout, color: Colors.red),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Keluar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.red),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFB74D)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb, color: Color(0xFFFF9800)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Pastikan semua data pribadi Anda sudah benar untuk pengalaman aplikasi yang optimal.",
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF5D4037)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for UI components
  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: child,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Text(
            "$label : ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
