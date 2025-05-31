import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'kalkulator.dart';

class StatistikPage extends StatefulWidget {
  @override
  _StatistikPageState createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage>
    with SingleTickerProviderStateMixin {
  // Sample data - in a real app, this would come from a database or state management
  List<double> weightHistory = [70, 68, 69, 67, 65, 64, 63, 65, 64];
  List<String> dateHistory = [
    '1 Apr',
    '8 Apr',
    '15 Apr',
    '22 Apr',
    '1 May',
    '8 May',
    '15 May',
    '22 May',
    '1 Jun'
  ];
  List<String> bmiCategories = [
    'Overweight',
    'Overweight',
    'Overweight',
    'Normal',
    'Normal',
    'Normal',
    'Normal',
    'Normal',
    'Normal'
  ];

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

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    double initialWeight = weightHistory.first;
    double currentWeight = weightHistory.last;
    double totalChange = currentWeight - initialWeight;
    double weeklyAverage =
        totalChange / (weightHistory.length > 1 ? weightHistory.length - 1 : 1);

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
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.hourglass_empty,
                              "Berat Awal",
                              "${initialWeight.toStringAsFixed(1)} kg",
                              Colors.blue.shade100,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoCard(
                              Icons.scale,
                              "Berat Saat Ini",
                              "${currentWeight.toStringAsFixed(1)} kg",
                              Colors.green.shade100,
                              primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.trending_up,
                              "Total Perubahan",
                              "${totalChange.toStringAsFixed(1)} kg",
                              totalChange >= 0
                                  ? Colors.orange.shade100
                                  : Colors.lightBlue.shade100,
                              totalChange >= 0
                                  ? Colors.orange
                                  : Colors.lightBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoCard(
                              Icons.calendar_month,
                              "Rata-rata/Minggu",
                              "${weeklyAverage.toStringAsFixed(1)} kg",
                              weeklyAverage >= 0
                                  ? Colors.purple.shade100
                                  : Colors.teal.shade100,
                              weeklyAverage >= 0 ? Colors.purple : Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Chart Card
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.show_chart,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Grafik Perkembangan",
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
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.3),
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.3),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() % 2 == 0 &&
                                        value.toInt() >= 0 &&
                                        value.toInt() < dateHistory.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          dateHistory[value.toInt()],
                                          style: const TextStyle(
                                            color: Color(0xFF2E7D32),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            minX: 0,
                            maxX: weightHistory.length.toDouble() - 1,
                            minY:
                                (weightHistory.reduce(min) - 5).clamp(30, 150),
                            maxY:
                                (weightHistory.reduce(max) + 5).clamp(30, 150),
                            lineBarsData: [
                              LineChartBarData(
                                spots: weightHistory
                                    .asMap()
                                    .entries
                                    .map((e) =>
                                        FlSpot(e.key.toDouble(), e.value))
                                    .toList(),
                                isCurved: true,
                                color: primaryColor,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: primaryColor,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      primaryColor.withOpacity(0.3),
                                      primaryColor.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

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
                              color: _getBMICategoryColor(bmiCategories[index])
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
                                            bmiCategories[index])
                                        .withOpacity(0.2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.scale,
                                      color: _getBMICategoryColor(
                                          bmiCategories[index]),
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
                                        dateHistory[index],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Berat: ${weightHistory[index].toStringAsFixed(1)} kg",
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
                                            bmiCategories[index])
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    bmiCategories[index],
                                    style: TextStyle(
                                      color: _getBMICategoryColor(
                                          bmiCategories[index]),
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
