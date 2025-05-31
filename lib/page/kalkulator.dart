import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obecity_projectsem4/utils/request-url.dart';

void main() {
  runApp(IMTPage());
}

class IMTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Kalkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
      ),
      home: BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage>
    with SingleTickerProviderStateMixin {
  // Color Constants
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String gender = 'Laki-laki';
  String alcoholUse = 'Tidak';
  String familyObesity = 'Tidak';
  String physicalActivity = 'Tidak';
  String painComplaint = 'Tidak';
  String instantNoodles = 'Tidak';
  String prediction = '';
  bool isLoading = false;

  int currentPageIndex = 3; // IMT page is the 4th index

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;

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
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

// API Function - VERSI DIPERBAIKI
  Future<void> kirimKeAPI() async {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);
    final age = double.tryParse(ageController.text);

    if (height == null || weight == null || age == null) {
      setState(() {
        prediction = 'Masukkan data yang valid untuk tinggi, berat, dan umur';
      });
      return;
    }

    setState(() {
      isLoading = true;
      prediction = '';
    });

    // PILIH SALAH SATU URL:
    // Untuk Android Emulator:
    final url = Uri.parse("$baseUrl/predict");

    // Untuk Device Fisik (uncomment jika pakai HP):
    // final url = Uri.parse('http://192.168.19.211:8000/api/predict');

    // Convert form data to numerical values
    int genderValue = gender == 'Laki-laki' ? 1 : 0;
    int alcoholValue = alcoholUse == 'Ya' ? 1 : 0;
    int familyObesityValue = familyObesity == 'Ya' ? 1 : 0;
    int physicalActivityValue = physicalActivity == 'Ya' ? 1 : 0;
    int painComplaintValue = painComplaint == 'Ya' ? 1 : 0;
    int instantNoodlesValue = instantNoodles == 'Ya' ? 1 : 0;

    // FORMAT DATA UNTUK LARAVEL (object, bukan array)
    final data = {
      "gender": genderValue,
      "age": age.toInt(),
      "height": height.toInt(),
      "weight": weight.toInt(),
      "alcohol": alcoholValue,
      "family_obesity": familyObesityValue,
      "physical_activity": physicalActivityValue,
      "pain_complaint": painComplaintValue,
      "instant_noodles": instantNoodlesValue
    };

    try {
      print('🚀 Mengirim request ke: $url');
      print('📊 Data yang dikirim: $data');

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 15));

      print('📱 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          // Sesuaikan dengan response dari Laravel
          prediction = result['prediction'] ??
              result['category'] ??
              'BMI: ${result['bmi']} - ${result['risk'] ?? 'Unknown'}';
          isLoading = false;
        });
      } else {
        setState(() {
          prediction =
              'Error dari server: ${response.statusCode}\nDetail: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        prediction = 'Gagal terhubung ke server: $e';
        isLoading = false;
      });
      print('❌ Error detail: $e');
    }
  }

  // Glass card widget
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: child,
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
                  // Title Card
                  _buildGlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calculate,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Kalkulator BMI',
                          style: TextStyle(
                            fontSize: 20,
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

                  // Input Data Card
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Masukkan Data Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Umur (tahun)', ageController),
                        _buildTextField('Tinggi Badan (cm)', heightController),
                        _buildTextField('Berat Badan (kg)', weightController),
                        _buildDropdown(
                          'Jenis Kelamin',
                          ['Laki-laki', 'Perempuan'],
                          gender,
                          (val) => setState(() => gender = val!),
                        ),
                        _buildDropdown(
                          'Sering Mengkonsumsi Alkohol?',
                          ['Ya', 'Tidak'],
                          alcoholUse,
                          (val) => setState(() => alcoholUse = val!),
                        ),
                        _buildDropdown(
                          'Riwayat Keluarga Obesitas?',
                          ['Ya', 'Tidak'],
                          familyObesity,
                          (val) => setState(() => familyObesity = val!),
                        ),
                        _buildDropdown(
                          'Sering Aktivitas Fisik?',
                          ['Ya', 'Tidak'],
                          physicalActivity,
                          (val) => setState(() => physicalActivity = val!),
                        ),
                        _buildDropdown(
                          'Apakah Sering Nyeri?',
                          ['Ya', 'Tidak'],
                          painComplaint,
                          (val) => setState(() => painComplaint = val!),
                        ),
                        _buildDropdown(
                          'Sering Mengkonsumsi Makanan Berkalori Tinggi?',
                          ['Ya', 'Tidak'],
                          instantNoodles,
                          (val) => setState(() => instantNoodles = val!),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading ? null : kirimKeAPI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Hitung BMI',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  // Prediction Result Card
                  if (prediction.isNotEmpty)
                    _buildGlassCard(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: prediction.contains('Error') ||
                                  prediction.contains('Gagal')
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: prediction.contains('Error') ||
                                    prediction.contains('Gagal')
                                ? const Color(0xFFE57373)
                                : const Color(0xFF2196F3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  prediction.contains('Error') ||
                                          prediction.contains('Gagal')
                                      ? Icons.warning
                                      : Icons.health_and_safety,
                                  color: prediction.contains('Error') ||
                                          prediction.contains('Gagal')
                                      ? const Color(0xFFE57373)
                                      : const Color(0xFF2196F3),
                                  size: 28,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Prediksi Risiko Obesitas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: prediction.contains('Error') ||
                                            prediction.contains('Gagal')
                                        ? const Color(0xFFD32F2F)
                                        : const Color(0xFF1976D2),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                prediction,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: prediction.contains('Error') ||
                                          prediction.contains('Gagal')
                                      ? const Color(0xFFD32F2F)
                                      : primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Informational Tip Card
                  _buildGlassCard(
                    child: Container(
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
                              "Masukkan data dengan akurat untuk mendapatkan perhitungan BMI yang tepat!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5D4037),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height != null && weight != null) {
      final bmi = weight / ((height / 100) * (height / 100));

      // Determine BMI Category
      String bmiCategory;
      if (bmi < 18.5) {
        bmiCategory = "Underweight";
      } else if (bmi < 25) {
        bmiCategory = "Normal";
      } else if (bmi < 30) {
        bmiCategory = "Overweight";
      } else {
        bmiCategory = "Obese";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Hasil BMI',
            style: TextStyle(color: primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BMI Anda: ${bmi.toStringAsFixed(2)}'),
              Text('Kategori: $bmiCategory'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Tutup',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Masukkan tinggi dan berat badan yang valid'),
          backgroundColor: primaryColor,
        ),
      );
    }
  }
}
