import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1. Check local storage if onboarding was completed
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  // 2. Check if a user is already authenticated in Firebase
  final User? user = FirebaseAuth.instance.currentUser;

  // 3. Determine the initial landing page
  String initialRoute = '/';
  if (!showOnboarding) {
    initialRoute = (user != null) ? '/home' : '/login';
  }

  runApp(SpendWiseApp(initialRoute: initialRoute));
}

class SpendWiseApp extends StatelessWidget {
  final String initialRoute;
  const SpendWiseApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainDashboard(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}