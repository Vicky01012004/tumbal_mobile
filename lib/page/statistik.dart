import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:obecity_projectsem4/page/beranda_ui.dart';
import 'package:obecity_projectsem4/utils/request-url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'kalkulator.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  _StatistikPageState createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage>
    with SingleTickerProviderStateMixin {
  // Sample data - in a real app, this would come from a database or state management
  List<ChartWeight> weightHistory = [];
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  // Colors consistent with BerandaPage
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  int currentPageIndex = 1; // For navigation bar

  @override
  void initState() {
    super.initState();

    _loadHistoryData();
    // Initialize animations
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

  Color _getBMICategoryColor(String category) {
    switch (category) {
      case "Underweight":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      case "Obese":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _loadHistoryData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var url = Uri.parse("$baseUrl/auth/history");
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    print(token);
    if (response.statusCode == 200) {
      List body = json.decode(response.body)['data'];
      setState(() {
        weightHistory = body.map((val) => ChartWeight.fromJson(val)).toList();
      });
    } else {
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 3),
        title: "Error",
        message: "Oopppss ada kesalahan.. ",
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    // double initialWeight = weightHistory.first;
    // double currentWeight = weightHistory.last;
    // double totalChange = currentWeight - initialWeight;
    // double weeklyAverage =
    //     totalChange / (weightHistory.length > 1 ? weightHistory.length - 1 : 1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Statistik Berat Badan",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 60), // Space for AppBar

                // Summary Card
                _buildGlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.analytics_outlined,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Ringkasan Berat Badan',
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
                      const SizedBox(height: 20),

                      // Summary Grid
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: _buildInfoCard(
                      //         Icons.hourglass_empty,
                      //         "Berat Awal",
                      //         "${initialWeight.toStringAsFixed(1)} kg",
                      //         Colors.blue.shade100,
                      //         Colors.blue,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Expanded(
                      //       child: _buildInfoCard(
                      //         Icons.scale,
                      //         "Berat Saat Ini",
                      //         "${currentWeight.toStringAsFixed(1)} kg",
                      //         Colors.green.shade100,
                      //         primaryColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: _buildInfoCard(
                      //         Icons.trending_up,
                      //         "Total Perubahan",
                      //         "${totalChange.toStringAsFixed(1)} kg",
                      //         totalChange >= 0
                      //             ? Colors.orange.shade100
                      //             : Colors.lightBlue.shade100,
                      //         totalChange >= 0
                      //             ? Colors.orange
                      //             : Colors.lightBlue,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Expanded(
                      //       child: _buildInfoCard(
                      //         Icons.calendar_month,
                      //         "Rata-rata/Minggu",
                      //         "${weeklyAverage.toStringAsFixed(1)} kg",
                      //         weeklyAverage >= 0
                      //             ? Colors.purple.shade100
                      //             : Colors.teal.shade100,
                      //         weeklyAverage >= 0 ? Colors.purple : Colors.teal,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 20),

                // History Card
                _buildGlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Riwayat Berat Badan",
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

                      // History list with modern design
                      ...List.generate(
                        weightHistory.length,
                        (index) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 0,
                          color: Colors.white.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: _getBMICategoryColor(
                                      weightHistory[index].kategoriBmi)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getBMICategoryColor(
                                            weightHistory[index]
                                                .tanggal
                                                .toString())
                                        .withOpacity(0.2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.scale,
                                      color: _getBMICategoryColor(
                                          weightHistory[index].kategoriBmi),
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            weightHistory[index].tanggal),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Berat: ${weightHistory[index].newWeight.toStringAsFixed(1)} kg",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getBMICategoryColor(
                                            weightHistory[index].kategoriBmi)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    weightHistory[index].kategoriBmi,
                                    style: TextStyle(
                                      color: _getBMICategoryColor(
                                          weightHistory[index].kategoriBmi),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tip card
                      Container(
                        padding: const EdgeInsets.all(12),
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
                                "Perubahan berat badan yang sehat adalah 0.5-1 kg per minggu. Terlalu cepat dapat mempengaruhi kesehatan dan tidak berkelanjutan.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF5D4037),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
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

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String value,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: iconColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
