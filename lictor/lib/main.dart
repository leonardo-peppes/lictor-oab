// lib/main.dart
// Ponto de entrada do Lictor MVP

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura orientação portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Carrega SharedPreferences antes de iniciar o app
  final prefs = await SharedPreferences.getInstance();

  // Inicia com ProviderScope e injeta SharedPreferences
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const LictorApp(),
    ),
  );
}
