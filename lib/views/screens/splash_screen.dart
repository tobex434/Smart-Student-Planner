import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // small delay so splash is visible while app loads
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authCtrl = context.read<AuthController>();

    if (authCtrl.isLoggedIn) {
      // if user is already logged in go straight to app
      _go(const MainShell());
    } else {
      // check if any account exists in SQLite
      final hasAccount = await authCtrl.hasExistingAccount();
      _go(hasAccount ? const LoginScreen() : const LandingScreen());
    }
  }

  void _go(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.bookmark, color: Colors.white, size: 44),
            ),

            const SizedBox(height: 20),

            // app name
            const Text(
              'ScholarSync',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
