import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const ScholarSyncApp());
}

class ScholarSyncApp extends StatelessWidget {
  const ScholarSyncApp({super.key});
  // This is the app's default color, it serves as a fallback if obtaininig wallpaper color fails
  static const Color _seedColour = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    // the dynamic color wrapper widgets grabs the os wallpaper colors
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Build light scheme
        // this checks If the phone supports dynamic colour, use it — otherwise use our default color we initailised earlier
        final lightScheme =
            lightDynamic ??
            ColorScheme.fromSeed(
              seedColor: _seedColour,
              brightness: Brightness.light,
            );

        // Build dark scheme
        final darkScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: _seedColour,
              brightness: Brightness.dark,
            );

        return MaterialApp(
          // materialapp is the main entry point of the app, we'll be adding navigation, themes.
          title: 'ScholarSync',
          debugShowCheckedModeBanner:
              false, // removes the debug banner top right
          // Light theme
          theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),

          // Dark theme
          darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),

          // Follows the phone's system setting for now
          // User will be able to override this from Profile screen later
          themeMode: ThemeMode.system,

          // We'll add routes here as we create each screen
          home: const Scaffold(
            body: Center(child: Text('ScholarSync is alive 🎉')),
          ),
        );
      },
    );
  }
}
