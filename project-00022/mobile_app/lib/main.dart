import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService.init();
  runApp(const HangmanEscapeApp());
}

class HangmanEscapeApp extends StatelessWidget {
  const HangmanEscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Escape',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
