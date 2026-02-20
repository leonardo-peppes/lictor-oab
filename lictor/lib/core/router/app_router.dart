// lib/core/router/app_router.dart
// Configuração de rotas com GoRouter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/questions/screens/training_screen.dart';
import '../../features/explanation/screens/explanation_screen.dart';
import '../../features/simulation/screens/simulation_screen.dart';
import '../../features/simulation/screens/simulation_result_screen.dart';
import '../../features/stats/screens/stats_screen.dart';
import '../../features/subscription/screens/premium_screen.dart';
import '../../features/questions/models/question_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppConstants.routeSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOnboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSignup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppConstants.routeDashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppConstants.routeTraining,
        builder: (context, state) => const TrainingScreen(),
      ),
      GoRoute(
        path: AppConstants.routeExplanation,
        builder: (context, state) {
          final question = state.extra as Question;
          final selectedAnswer = state.uri.queryParameters['answer'] ?? '';
          return ExplanationScreen(
            question: question,
            selectedAnswer: selectedAnswer,
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeSimulation,
        builder: (context, state) => const SimulationScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSimulationResult,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SimulationResultScreen(
            totalQuestions: extra['totalQuestions'] as int,
            correctAnswers: extra['correctAnswers'] as int,
            answers: extra['answers'] as List<Map<String, dynamic>>,
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeStats,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppConstants.routePremium,
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
  );
});
