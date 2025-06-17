import 'package:flutter/material.dart';
import 'package:obecity_projectsem4/beranda.dart';
import 'login_screen.dart';
import 'wigdets/custom_button.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _rotateAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Fade and slide animations
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    // Rotating animation for health elements
    _rotateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    // Pulse animation for the logo
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _rotateAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFCDEDC1),
                  Color(0xFFA5D6A7),
                ],
              ),
            ),
          ),
          
          // Animated Background Elements - Rotating circles
          Positioned(
            top: -100,
            left: -100,
            child: AnimatedBuilder(
              animation: _rotateAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4CAF50).withOpacity(0.2),
                      const Color(0xFF81C784).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: -150,
            right: -50,
            child: AnimatedBuilder(
              animation: _rotateAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -_rotateAnimationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF007C79).withOpacity(0.2),
                      const Color(0xFF009688).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Floating health elements
          ...buildHealthElements(),
          
          // Main content
          SafeArea(
            child: AnimatedBuilder(
              animation: _fadeAnimationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeInAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      
                      // Logo with pulse animation
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 2,
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
                      ),

                      const SizedBox(height: 40),

                      // App Title
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
                          'ObesCheck',
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Slogan with decoration
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          '"Kendalikan berat badan, mulai dari sini."',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2E7D32),
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const Spacer(flex: 1),

                      // Healthy lifestyle message
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Color(0xFFE57373),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Hidup Sehat, Hidup Bahagia',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.fitness_center,
                              color: Color(0xFF5D4037),
                              size: 20,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Start Button
                      CustomButton(
                        text: 'Mulai Perjalanan Sehat',
                        icon: Icons.directions_run,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              // pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                              pageBuilder: (context, animation, secondaryAnimation) => BerandaPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.easeOutCubic;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 800),
                            ),
                          );
                        },
                        backgroundColor: const Color(0xFF2E7D32),
                        height: 60,
                      ),
                      
                      const Spacer(flex: 2),
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
  
  List<Widget> buildHealthElements() {
    return [
      // Apple
      Positioned(
        top: 120,
        right: 30,
        child: AnimatedBuilder(
          animation: _fadeAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeInAnimation.value * 0.8,
              child: child,
            );
          },
          child: Transform.rotate(
            angle: -0.2,
            child: const Icon(
              Icons.apple,
              color: Color(0xFFE57373),
              size: 34,
            ),
          ),
        ),
      ),
      
      // Running person
      Positioned(
        bottom: 140,
        left: 30,
        child: AnimatedBuilder(
          animation: _fadeAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeInAnimation.value * 0.8,
              child: child,
            );
          },
          child: const Icon(
            Icons.directions_run,
            color: Color(0xFF5D4037),
            size: 38,
          ),
        ),
      ),
      
      // Measuring tape
      Positioned(
        top: 230,
        left: 40,
        child: AnimatedBuilder(
          animation: _fadeAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeInAnimation.value * 0.8,
              child: child,
            );
          },
          child: Transform.rotate(
            angle: 0.3,
            child: const Icon(
              Icons.straighten,
              color: Color(0xFF9575CD),
              size: 36,
            ),
          ),
        ),
      ),
      
      // Water drop
      Positioned(
        bottom: 200,
        right: 40,
        child: AnimatedBuilder(
          animation: _fadeAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeInAnimation.value * 0.8,
              child: child,
            );
          },
          child: const Icon(
            Icons.water_drop,
            color: Color(0xFF64B5F6),
            size: 32,
          ),
        ),
      ),
    ];
  }
}