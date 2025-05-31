import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanPage extends StatefulWidget {
  @override
  _PengaturanPageState createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  // User profile settings
  String userName = "";
  String userGender = "Pria";
  double userHeight = 170;
  String birthDate = "01/01/1990";
  String userEmail = "pengguna@email.com";

  // App settings
  bool enableNotifications = true;
  bool darkMode = false;
  String weightUnit = "kg";
  String heightUnit = "cm";
  String language = "Bahasa Indonesia";

  // Health goals
  String targetWeight = "60";
  String weeklyGoal = "0.5 kg";
  String activityLevel = "Aktif Sedang";

  @override
  void initState() {
    getUserLogin();
    super.initState();
  }

  void getUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("nama")!;
      userEmail = prefs.getString("email")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 20),
            _buildAppSettingsSection(),
            SizedBox(height: 20),
            _buildHealthGoalsSection(),
            SizedBox(height: 20),
            _buildAccountSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.recommend), label: 'Rekomendasi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Statistik'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'IMT'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal,
                child: Text(
                  userName[0],
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.teal),
                onPressed: () {
                  // Open profile edit dialog
                  _showEditProfileDialog();
                },
              ),
            ],
          ),
          Divider(height: 30),
          _buildProfileItem("Jenis Kelamin", userGender, Icons.person),
          _buildProfileItem("Tinggi", "$userHeight $heightUnit", Icons.height),
          _buildProfileItem("Tanggal Lahir", birthDate, Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pengaturan Aplikasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildSwitchSetting(
            "Notifikasi",
            "Terima pengingat dan pemberitahuan",
            enableNotifications,
            (value) {
              setState(() {
                enableNotifications = value;
              });
            },
          ),
          _buildSwitchSetting(
            "Mode Gelap",
            "Ubah tampilan aplikasi menjadi gelap",
            darkMode,
            (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),
          _buildDropdownSetting(
            "Unit Berat",
            weightUnit,
            ["kg", "lbs"],
            (value) {
              setState(() {
                weightUnit = value!;
              });
            },
          ),
          _buildDropdownSetting(
            "Unit Tinggi",
            heightUnit,
            ["cm", "ft"],
            (value) {
              setState(() {
                heightUnit = value!;
              });
            },
          ),
          _buildDropdownSetting(
            "Bahasa",
            language,
            ["Bahasa Indonesia", "English"],
            (value) {
              setState(() {
                language = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGoalsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Target Kesehatan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildEditableSetting(
            "Target Berat Badan",
            "$targetWeight $weightUnit",
            () {
              // Show dialog to edit target weight
              _showEditWeightGoalDialog();
            },
          ),
          _buildDropdownSetting(
            "Target Mingguan",
            weeklyGoal,
            ["0.25 kg", "0.5 kg", "0.75 kg", "1 kg"],
            (value) {
              setState(() {
                weeklyGoal = value!;
              });
            },
          ),
          _buildDropdownSetting(
            "Tingkat Aktivitas",
            activityLevel,
            [
              "Jarang Aktif",
              "Aktif Ringan",
              "Aktif Sedang",
              "Sangat Aktif",
              "Ekstra Aktif"
            ],
            (value) {
              setState(() {
                activityLevel = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Akun",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildActionButton(
            "Ganti Password",
            "Ubah password akun Anda",
            Icons.lock,
            Colors.blue,
            () {
              // Show change password dialog
            },
          ),
          Divider(height: 16),
          _buildActionButton(
            "Ekspor Data",
            "Unduh semua data berat badan Anda",
            Icons.download,
            Colors.green,
            () {
              // Show export data dialog
            },
          ),
          Divider(height: 16),
          _buildActionButton(
            "Hapus Akun",
            "Hapus akun dan semua data Anda",
            Icons.delete_forever,
            Colors.red,
            () {
              // Show delete account confirmation
            },
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              "Versi Aplikasi: 1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(String title, String currentValue,
      List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          DropdownButton<String>(
            value: currentValue,
            onChanged: onChanged,
            underline: Container(
              height: 1,
              color: Colors.teal,
            ),
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSetting(String title, String value, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(color: Colors.teal),
                ),
                SizedBox(width: 4),
                Icon(Icons.edit, size: 16, color: Colors.teal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, String subtitle, IconData icon,
      Color color, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    // This would show a dialog to edit profile information
    // For demonstration purposes, only showing the method signature
  }

  void _showEditWeightGoalDialog() {
    // This would show a dialog to edit weight goal
    // For demonstration purposes, only showing the method signature
  }
}
