import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:obecity_projectsem4/login_screen.dart';
import 'package:obecity_projectsem4/utils/request-url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obecity_projectsem4/beranda.dart';
import 'package:obecity_projectsem4/wigdets/custom_button.dart'; // Tetap menggunakan 'wigdets' sesuai aslinya
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  DateTime? _selectedDate;
  String? _selectedGender;

  final _formKey = GlobalKey<FormState>();

  // Controller untuk form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // List gender options
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Tampilkan date picker untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);

        // Auto calculate age
        final now = DateTime.now();
        final age = now.year - picked.year;
        final monthDiff = now.month - picked.month;
        final dayDiff = now.day - picked.day;

        int calculatedAge = age;
        if (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) {
          calculatedAge = age - 1;
        }

        _ageController.text = calculatedAge.toString();
      });
    }
  }

  // Konstanta warna untuk konsistensi
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581);
  static const Color backgroundColor1 = Color(0xFFE8F5E9);
  static const Color backgroundColor2 = Color(0xFFCDEDC1);
  static const Color backgroundColor3 = Color(0xFFA5D6A7);

  // Metode untuk validasi form dan registrasi
  void _validateAndRegister() async {
    if (_formKey.currentState!.validate()) {
      // Implementasi registrasi
      var url = Uri.parse('$baseUrl/auth/register');
      //     'Nama'           => 'required|string|max:255',
      //     'Jenis_Kelamin'  => 'required|in:Laki-laki,Perempuan',
      //     'Usia'           => 'required|numeric',
      //     'Tinggi_Badan'   => 'required|numeric',
      //     'Berat_Badan'    => 'required|numeric',
      //     'email'          => 'required|email|unique:users,email',
      //     'password'       => 'required|confirmed|min:6',

      var body = {
        'Nama': _usernameController.text,
        'Jenis_Kelamin': _selectedGender ?? '',
        'Usia': _ageController.text,
        'Tinggi_Badan': _heightController.text,
        'Berat_Badan': _weightController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      var response = await http
          .post(url, body: body, headers: {"Accept": "application/json"});
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAll(() => LoginPage());
        // Registrasi berhasil, lanjutkan dengan login otomatis
        // var loginUrl = Uri.parse('$baseUrl/auth/register');
        // var loginBody = {
        //   'email': _emailController.text,
        //   'password': _passwordController.text
        // };

        // var loginResponse = await http.post(loginUrl, body: loginBody);

        // if (loginResponse.statusCode == 200) {
        //   var resBody = jsonDecode(loginResponse.body);

        //   final SharedPreferences prefs = await SharedPreferences.getInstance();
        //   prefs.setString("token", resBody['access_token']);
        //   prefs.setString("nama", resBody['user']['Nama']);
        //   prefs.setString("email", resBody['user']['email']);
        //   prefs.setString("role", resBody['user']['Role']);

        //   Get.offAll(() => BerandaPage());
        // } else {
        //   // Login gagal setelah registrasi berhasil
        //   Get.showSnackbar(GetSnackBar(
        //     duration: const Duration(seconds: 3),
        //     title: "Registrasi Berhasil",
        //     message: "Silahkan login dengan akun baru Anda",
        //     backgroundColor: primaryColor,
        //   ));

        //   // Navigasi ke halaman login
        //   Get.back(); // Kembali ke halaman login
        // }
      } else {
        // Registrasi gagal
        var errorMessage = "Registrasi gagal";
        try {
          var errorBody = jsonDecode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (e) {
          // Gagal parse error message
        }

        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Error",
          message: errorMessage,
          backgroundColor: Colors.red,
        ));
      }
    }
    //   catch (e) {
    //     print(e);
    //     Get.showSnackbar(GetSnackBar(
    //       duration: const Duration(seconds: 3),
    //       title: "Error",
    //       message: "Terjadi kesalahan koneksi",
    //       backgroundColor: Colors.red,
    //     ));
    //   }
    // }
  }

  // Metode untuk membuat input field dengan style yang konsisten
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isDate = false,
    bool isNumber = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? (controller == _passwordController
              ? _obscurePassword
              : _obscureConfirmPassword)
          : false,
      onTap: onTap,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor),
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (controller == _passwordController
                          ? _obscurePassword
                          : _obscureConfirmPassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    if (controller == _passwordController) {
                      _obscurePassword = !_obscurePassword;
                    } else {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }
                  });
                },
              )
            : (isDate
                ? const Icon(Icons.calendar_today, color: primaryColor)
                : null),
      ),
      validator: validator,
    );
  }

  // Metode untuk membuat dropdown field
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor),
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background dengan gradient
          Container(
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
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo dengan circle background
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(46, 125, 50, 0.3),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'assets/LogoObes.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title dengan gradient
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF007C79),
                            Color(0xFF004D40),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          "ObesityCheck",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Create Your Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Card dengan efek blur
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 25),

                                // Full Name field
                                _buildInputField(
                                  label: "Full Name",
                                  hint: "Enter your full name",
                                  icon: Icons.person,
                                  controller: _usernameController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 3) {
                                      return 'Nama minimal 3 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Gender dropdown
                                _buildDropdownField(
                                  label: "Jenis Kelamin",
                                  hint: "Pilih jenis kelamin",
                                  icon: Icons.wc,
                                  items: _genderOptions,
                                  value: _selectedGender,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pilih jenis kelamin';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Age field
                                _buildInputField(
                                  label: "Usia",
                                  hint: "Enter your Age Here",
                                  icon: Icons.calendar_month,
                                  controller: _ageController,
                                  isNumber: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan usia anda';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 1 || age > 120) {
                                      return 'Usia tidak valid';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Height field
                                _buildInputField(
                                  label: "Tinggi Badan",
                                  hint: "Enter your Height Here",
                                  icon: Icons.height,
                                  controller: _heightController,
                                  isNumber: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan tinggi badan anda';
                                    }
                                    final height = double.tryParse(value);
                                    if (height == null ||
                                        height < 50 ||
                                        height > 250) {
                                      return 'Tinggi badan tidak valid';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Weight field
                                _buildInputField(
                                  label: "Berat Badan",
                                  hint: "Enter your Weight Here",
                                  icon: Icons.monitor_weight,
                                  controller: _weightController,
                                  isNumber: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan berat badan anda';
                                    }
                                    final weight = double.tryParse(value);
                                    if (weight == null ||
                                        weight < 20 ||
                                        weight > 300) {
                                      return 'Berat badan tidak valid';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Email field dengan validasi
                                _buildInputField(
                                  label: "Email Address",
                                  hint: "Enter your email",
                                  icon: Icons.email,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Masukkan email yang valid';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Password field dengan validasi
                                _buildInputField(
                                  label: "Password",
                                  hint: "Enter your password",
                                  icon: Icons.lock,
                                  controller: _passwordController,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 8) {
                                      return 'Password minimal 8 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Confirm Password field
                                _buildInputField(
                                  label: "Confirm Password",
                                  hint: "Confirm your password",
                                  icon: Icons.lock_outline,
                                  controller: _confirmPasswordController,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Konfirmasi password anda';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Password tidak sama';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 25),

                                // Register button menggunakan CustomButton
                                CustomButton(
                                  text: "Register Account",
                                  icon: Icons.app_registration_rounded,
                                  onPressed: _validateAndRegister,
                                  backgroundColor: primaryColor,
                                  height: 56,
                                ),

                                const SizedBox(height: 20),

                                // Opsi login
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigasi kembali ke halaman login
                                        Get.back();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
