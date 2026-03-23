import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

/// Global notifier — toggling dark mode in Settings instantly rebuilds the theme.
final darkModeNotifier = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved dark mode preference before the app starts.
  final prefs = await SharedPreferences.getInstance();
  darkModeNotifier.value = prefs.getBool('darkMode') ?? false;

  runApp(const CampusBitesApp());
}

class CampusBitesApp extends StatelessWidget {
  const CampusBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (_, isDark, __) {
        return MaterialApp(
          title: 'CampusBites',
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
