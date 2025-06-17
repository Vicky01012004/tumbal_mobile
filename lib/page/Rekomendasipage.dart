import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obecity_projectsem4/utils/request-url.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  _RekomendasiPageState createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  String currentTarget = "Menurunkan";
  double currentWeight = 60;
  double targetWeight = 55;
  double height = 170;
  double bmi = 0;
  String bmiCategory = "";
  List listRekomendasi = [];

  List<Map<String, dynamic>> nutritionRecommendations = [];
  List<Map<String, dynamic>> exerciseRecommendations = [];

  @override
  void initState() {
    super.initState();
    calculateBMI();
    _generateRecommendations();
    getRekomendasi();
  }

  void calculateBMI() {
    double heightInMeters = height / 100;
    bmi = currentWeight / pow(heightInMeters, 2);

    if (bmi < 18.5) {
      bmiCategory = "Berat Badan Kurang";
    } else if (bmi < 25) {
      bmiCategory = "Berat Badan Normal";
    } else if (bmi < 30) {
      bmiCategory = "Kelebihan Berat Badan";
    } else {
      bmiCategory = "Obesitas";
    }
  }

  void getRekomendasi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.get(
      Uri.parse("$baseUrl/auth/rekomendasi"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    print(response.body);
    var body = json.decode(response.body);
    setState(() {
      listRekomendasi = body['data'];
    });
  }

  void _generateRecommendations() {
    // Reset recommendations
    nutritionRecommendations = [];
    exerciseRecommendations = [];

    if (currentTarget == "Menurunkan") {
      nutritionRecommendations = [
        {
          "title": "Porsi Terkontrol",
          "description": "Gunakan piring lebih kecil dan batasi porsi makanan",
          "icon": Icons.food_bank,
          "color": Colors.orange,
        },
        {
          "title": "Makanan Tinggi Serat",
          "description":
              "Buah, sayuran, dan biji-bijian membuat kenyang lebih lama",
          "icon": Icons.spa,
          "color": Colors.green,
        },
        {
          "title": "Kurangi Gula & Karbohidrat",
          "description":
              "Batasi makanan dengan gula tambahan dan karbohidrat olahan",
          "icon": Icons.no_food,
          "color": Colors.red,
        },
      ];

      exerciseRecommendations = [
        {
          "title": "Kardio Intensitas Tinggi",
          "description":
              "30-45 menit lari, bersepeda, atau berenang 3-5 kali seminggu",
          "icon": Icons.directions_run,
          "color": Colors.blue,
        },
        {
          "title": "Latihan Interval",
          "description":
              "Bergantian antara aktivitas intensitas tinggi dan pemulihan",
          "icon": Icons.timer,
          "color": Colors.purple,
        },
        {
          "title": "Latihan Kekuatan",
          "description": "Angkat beban 2-3 kali seminggu untuk membangun otot",
          "icon": Icons.fitness_center,
          "color": Colors.blueGrey,
        },
      ];
    } else if (currentTarget == "Menaikkan") {
      nutritionRecommendations = [
        {
          "title": "Tingkatkan Kalori",
          "description":
              "Tambahkan 300-500 kalori per hari dari makanan bergizi",
          "icon": Icons.add_circle,
          "color": Colors.green,
        },
        {
          "title": "Protein Tinggi",
          "description": "Konsumsi 1.6-2.2 gram protein per kg berat badan",
          "icon": Icons.egg_alt,
          "color": Colors.amber,
        },
        {
          "title": "Makan Lebih Sering",
          "description": "5-6 kali makan dalam porsi sedang setiap hari",
          "icon": Icons.access_time,
          "color": Colors.indigo,
        },
      ];

      exerciseRecommendations = [
        {
          "title": "Latihan Beban Progresif",
          "description": "Fokus pada gerakan compound dengan beban berat",
          "icon": Icons.fitness_center,
          "color": Colors.deepPurple,
        },
        {
          "title": "Istirahat Cukup",
          "description":
              "Beri otot waktu pemulihan 48-72 jam setelah latihan intensif",
          "icon": Icons.hotel,
          "color": Colors.teal,
        },
        {
          "title": "Kardio Terbatas",
          "description":
              "Batasi kardio hingga 20-30 menit untuk menjaga kalori",
          "icon": Icons.directions_walk,
          "color": Colors.cyan,
        },
      ];
    } else {
      nutritionRecommendations = [
        {
          "title": "Diet Seimbang",
          "description":
              "Konsumsi karbohidrat, protein, dan lemak dalam jumlah seimbang",
          "icon": Icons.balance,
          "color": Colors.teal,
        },
        {
          "title": "Makanan Utuh",
          "description":
              "Prioritaskan bahan makanan segar dan hindari makanan olahan",
          "icon": Icons.eco,
          "color": Colors.green,
        },
        {
          "title": "Hidrasi Optimal",
          "description":
              "Minum 2-3 liter air per hari untuk fungsi tubuh optimal",
          "icon": Icons.water_drop,
          "color": Colors.blue,
        },
      ];

      exerciseRecommendations = [
        {
          "title": "Aktivitas Konsisten",
          "description":
              "Lakukan minimal 150 menit aktivitas sedang per minggu",
          "icon": Icons.loop,
          "color": Colors.amber,
        },
        {
          "title": "Latihan Kombinasi",
          "description":
              "Gabungkan kardio dan latihan kekuatan untuk kesehatan optimal",
          "icon": Icons.sync_alt,
          "color": Colors.purple,
        },
        {
          "title": "Aktivitas Sehari-hari",
          "description":
              "Tingkatkan gerakan dalam rutinitas harian seperti jalan kaki",
          "icon": Icons.directions_walk,
          "color": Colors.deepOrange,
        },
      ];
    }
  }

  void _updateTarget(String target) {
    setState(() {
      currentTarget = target;
      if (target == "Menurunkan") {
        targetWeight =
            currentWeight - 5 > 0 ? currentWeight - 5 : currentWeight;
      } else if (target == "Menaikkan") {
        targetWeight = currentWeight + 5;
      } else {
        targetWeight = currentWeight;
      }
    });
    _generateRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Rekomendasi'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Target Berat Badan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     _buildTargetButton("Menurunkan", Colors.blue),
                  //     const SizedBox(width: 8),
                  //     _buildTargetButton("Mempertahankan", Colors.green),
                  //     const SizedBox(width: 8),
                  //     _buildTargetButton("Menaikkan", Colors.orange),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Berat Saat Ini"),
                          Text(
                            "${currentWeight.toStringAsFixed(1)} kg",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Target Berat"),
                          Text(
                            "${targetWeight.toStringAsFixed(1)} kg",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getInfoColor().withOpacity(0.1),
                      border: Border.all(color: _getInfoColor()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: _getInfoColor()),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_getInfoText()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "REKOMENDASI NUTRISI DAN LATIHAN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: listRekomendasi
                  .map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 1,
                      child: item['saran_makanan'] != null
                          ? ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: const Icon(
                                    CupertinoIcons.leaf_arrow_circlepath,
                                    color: Colors.green),
                              ),
                              title: const Text("Saran Makanan",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(item["saran_makanan"]),
                            )
                          : ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: const Icon(
                                    CupertinoIcons.leaf_arrow_circlepath,
                                    color: Colors.green),
                              ),
                              title: const Text("Saran Latihan",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(item["saran_aktivitas"]),
                            ),
                    ),
                  )
                  .toList(),
            ),
            // Column(
            //   children: nutritionRecommendations
            //       .map((item) => _buildRecommendationCard(item))
            //       .toList(),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetButton(String title, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _updateTarget(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: currentTarget == title ? color : Colors.grey[200],
          foregroundColor: currentTarget == title ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item["color"].withOpacity(0.2),
          child: Icon(item["icon"], color: item["color"]),
        ),
        title: Text(item["title"],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item["description"]),
      ),
    );
  }

  Color _getInfoColor() {
    if (currentTarget == "Menurunkan") return Colors.blue;
    if (currentTarget == "Menaikkan") return Colors.orange;
    return Colors.green;
  }

  String _getInfoText() {
    if (currentTarget == "Menurunkan") {
      return "Target penurunan 0.5-1 kg per minggu dengan defisit kalori 500-1000 per hari";
    } else if (currentTarget == "Menaikkan") {
      return "Target kenaikan 0.25-0.5 kg per minggu dengan surplus kalori 300-500 per hari";
    } else {
      return "Jaga berat badan ideal dengan keseimbangan kalori dan aktivitas fisik teratur";
    }
  }
}
