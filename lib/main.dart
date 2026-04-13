import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/theme_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/matiere_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await ConnectivityService.init();
  runApp(const GeoCoursApp());
}

class GeoCoursApp extends StatefulWidget {
  const GeoCoursApp({super.key});

  @override
  State<GeoCoursApp> createState() => _GeoCoursAppState();
}

class _GeoCoursAppState extends State<GeoCoursApp> {
  bool _showSplash = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_complete') ?? false;
    setState(() {
      _showOnboarding = !completed;
    });
  }

  void _splashComplete() {
    setState(() => _showSplash = false);
  }

  void _onboardingComplete() {
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()..init()),
        ChangeNotifierProvider(create: (_) => MatiereProvider()..init()),
        ChangeNotifierProvider(create: (_) => ChatProvider()..init()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          if (_showSplash) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(onComplete: _splashComplete),
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
            );
          }
          if (_showOnboarding) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: OnboardingScreen(onComplete: _onboardingComplete),
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
            );
          }
          return MaterialApp(
            title: 'GEOCOURS',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
