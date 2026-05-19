import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'controllers/task_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/timer_controller.dart';
import 'controllers/theme_controller.dart';
import 'views/screens/main_shell.dart';
import 'views/screens/splash_screen.dart';

void main() async {
  // ensures Flutter is ready before async work
  WidgetsFlutterBinding.ensureInitialized();

  // ── load all controllers before app renders ──
  final taskController = TaskController();
  final authController = AuthController();
  final timerController = TimerController();
  final themeController = ThemeController();

  authController.setTaskController(taskController);

  await authController.loadFromPrefs();
  await timerController.loadFromPrefs();
  await themeController.loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: taskController),
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider.value(value: timerController),
        ChangeNotifierProvider.value(value: themeController),
      ],
      child: const ScholarSyncApp(),
    ),
  );
}

class ScholarSyncApp extends StatelessWidget {
  const ScholarSyncApp({super.key});
  static const Color _fallbackSeed = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    // ── watch ThemeController — whole app rebuilds on theme change ──
    final themeCtrl = context.watch<ThemeController>();

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (themeCtrl.useDynamicColour && lightDynamic != null) {
          // Android 12+ wallpaper colours
          lightScheme = lightDynamic.harmonized();
          darkScheme = darkDynamic!.harmonized();
        } else {
          // fallback to seed colour
          lightScheme = ColorScheme.fromSeed(
            seedColor: themeCtrl.seedColour,
            brightness: Brightness.light,
          );
          darkScheme = ColorScheme.fromSeed(
            seedColor: themeCtrl.seedColour,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          // materialapp is the main entry point of the app, we'll be adding navigation, themes.
          title: 'ScholarSync',
          debugShowCheckedModeBanner:
              false, // removes the debug banner top right
          // reads from controller — not hardcoded anymore
          themeMode: themeCtrl.themeMode,
          theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),

          // We'll add routes here as we create each screen
          home: const SplashScreen(),
        );
      },
    );
  }
}
