import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const BhooGyanApp());
}

class BhooGyanApp extends StatelessWidget {
  const BhooGyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BhooGyan',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E1E24),
                border: Border.all(color: const Color(0xFFFFD700), width: 2),
              ),
              child: const Icon(
                Icons.landscape_rounded,
                size: 70,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'भू-ज्ञान (BhooGyan)',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'भूमि, निर्माण एवं वित्तीय कैलकुलेटर',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const Spacer(),
            const Text(
              'Powered by Umesh Kushwaha',
              style: TextStyle(
                color: Color(0xFFFFE66D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
