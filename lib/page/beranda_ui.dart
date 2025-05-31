// ===== MAIN PAGE WITH NAVIGATION (FIXED) =====
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:obecity_projectsem4/page/beranda_ui.dart';
import 'package:obecity_projectsem4/page/setting.dart';
import 'package:obecity_projectsem4/page/Rekomendasipage.dart';
import 'dart:math';
import 'package:obecity_projectsem4/wigdets/custom_button.dart';


class BerandaUI extends StatefulWidget {
  const BerandaUI({super.key});

  @override
  State<BerandaUI> createState() => _BerandaUIState();
}

class _BerandaUIState extends State<BerandaUI>
    with SingleTickerProviderStateMixin {
  
  // ===== DATA VARIABLES (PERLU BACKEND INTEGRATION) =====
  double currentWeight = 60;
  double currentHeight = 170; 
  List<WeightEntry> weightHistory = [];
  String bmiCategory = "Normal";
  String inputDate = "";
  
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

  // Konstanta warna
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData(); // PERLU IMPLEMENTASI BACKEND
  }

  void _initializeAnimations() {
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

  // ===== BACKEND INTEGRATION METHODS =====
  
  Future<void> _loadUserData() async {
    // TODO: Implementasi load data user dari backend
    setState(() {
      // Temporary data - hapus setelah backend ready
      weightHistory = [
        WeightEntry(weight: 65, date: DateTime.now().subtract(Duration(days: 8))),
        WeightEntry(weight: 63, date: DateTime.now().subtract(Duration(days: 7))),
        WeightEntry(weight: 61, date: DateTime.now().subtract(Duration(days: 6))),
        WeightEntry(weight: 59, date: DateTime.now().subtract(Duration(days: 5))),
        WeightEntry(weight: 60, date: DateTime.now().subtract(Duration(days: 4))),
      ];
    });
  }

  Future<void> _saveWeightData() async {
    // TODO: Implementasi save ke backend
    try {
      // API call untuk save berat badan
      // await WeightService.saveWeight(currentWeight, DateTime.now());
      
      // Update local state setelah berhasil save
      setState(() {
        weightHistory.add(WeightEntry(
          weight: currentWeight, 
          date: DateTime.now()
        ));
        inputDate = "${DateTime.now().day}.${DateTime.now().month}";
      });
      
      _showSuccessMessage("Berat badan berhasil disimpan!");
    } catch (e) {
      _showErrorMessage("Gagal menyimpan data: ${e.toString()}");
    }
  }

  void _calculateBMI() {
    if (currentHeight > 0) {
      double heightInMeters = currentHeight / 100;
      double bmi = currentWeight / pow(heightInMeters, 2);
      
      String category;
      if (bmi < 18.5) {
        category = "Underweight";
      } else if (bmi < 25) {
        category = "Normal";
      } else if (bmi < 30) {
        category = "Overweight";
      } else {
        category = "Obese";
      }

      setState(() {
        bmiCategory = category;
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Gunakan Scaffold dengan body transparan untuk slider
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          return Opacity(
            opacity: _fadeInAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value * 100),
              child: child,
            ),
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            // PERBAIKAN: Tambah padding bottom untuk memberi ruang footer
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              children: [
                // Header manual
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Input Berat Badan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Weight Input Card
                _buildGlassCard(
                  child: Column(
                    children: [
                      _buildCardHeader(
                        icon: Icons.scale,
                        title: 'Input Berat Badan Saat Ini',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${currentWeight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: currentWeight,
                        min: 30,
                        max: 150,
                        divisions: 240,
                        label: currentWeight.toStringAsFixed(1),
                        activeColor: primaryColor,
                        inactiveColor: secondaryColor.withOpacity(0.5),
                        onChanged: (value) {
                          setState(() {
                            currentWeight = value;
                            _calculateBMI();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: "Simpan",
                        icon: Icons.save,
                        onPressed: _saveWeightData,
                        backgroundColor: primaryColor,
                        height: 50,
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
                      _buildCardHeader(
                        icon: Icons.show_chart,
                        title: "Grafik Perkembangan",
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildWeightChart(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Status Card
                _buildGlassCard(
                  child: Column(
                    children: [
                      _buildCardHeader(
                        icon: Icons.info_outline,
                        title: "Status Kesehatan",
                      ),
                      const SizedBox(height: 16),
                      _buildStatusRow(
                        icon: Icons.category,
                        label: "BMI Status",
                        value: bmiCategory,
                        valueColor: _getBMICategoryColor(bmiCategory),
                      ),
                      _buildStatusRow(
                        icon: Icons.calendar_today,
                        label: "Tanggal Input",
                        value: inputDate.isEmpty ? "Belum ada input" : inputDate,
                      ),
                      _buildStatusRow(
                        icon: Icons.scale,
                        label: "Berat Badan Saat Ini",
                        value: "${currentWeight.toStringAsFixed(1)} kg",
                      ),
                      _buildStatusRow(
                        icon: Icons.history,
                        label: "Berat Badan Terakhir",
                        value: weightHistory.isEmpty
                            ? "Belum ada data"
                            : "${weightHistory.last.weight.toStringAsFixed(1)} kg",
                      ),
                      const SizedBox(height: 12),
                      _buildTipCard(),
                    ],
                  ),
                ),
                
                // PERBAIKAN: Hapus SizedBox di akhir karena sudah ada padding bottom
              ],
            ),
          ),
        ),
      ),
     )
    );
  }

  // ===== UI HELPER METHODS =====
  
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
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: child,
    );
  }

  Widget _buildCardHeader({required IconData icon, required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          title,
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
    );
  }

  Widget _buildStatusRow({
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
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
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
          Icon(Icons.lightbulb, color: Color(0xFFFF9800), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Jangan lupa input berat badan secara rutin untuk melihat perkembangan kesehatanmu!",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5D4037),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart() {
    if (weightHistory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "Belum ada data untuk ditampilkan",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return LineChart(
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
                if (value.toInt() < weightHistory.length) {
                  return Text(
                    "${weightHistory[value.toInt()].date.day}/${weightHistory[value.toInt()].date.month}",
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt()}kg",
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
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
        maxX: (weightHistory.length - 1).toDouble(),
        minY: weightHistory.isEmpty ? 40 : 
              weightHistory.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 5,
        maxY: weightHistory.isEmpty ? 100 : 
              weightHistory.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 5,
        lineBarsData: [
          LineChartBarData(
            spots: weightHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
                .toList(),
            isCurved: true,
            color: primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
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
          ),
        ],
      ),
    );
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// ===== DATA MODELS (PERLU BACKEND INTEGRATION) =====
class WeightEntry {
  final double weight;
  final DateTime date;
  final String? notes;

  WeightEntry({
    required this.weight,
    required this.date,
    this.notes,
  });

  // TODO: Implementasi JSON serialization untuk API
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      weight: json['weight'].toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}