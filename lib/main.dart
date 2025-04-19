import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'store_screen.dart';
import 'buy_screen.dart';
import 'achievement_screen.dart';
import 'quiz_screen.dart';
import 'quiz_engine.dart'; // ✅ NEW IMPORT

void main() {
  runApp(const FinEduApp());
}

class FinEduApp extends StatefulWidget {
  const FinEduApp({super.key});

  @override
  State<FinEduApp> createState() => _FinEduAppState();
}

class _FinEduAppState extends State<FinEduApp> {
  int points = 120;
  int coins = 35;

  void updatePoints(int value) {
    setState(() {
      points += value;
    });
  }

  void updateCoins(int value) {
    setState(() {
      coins += value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinEdu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: HomeScreen(
        userName: 'Sarah',
        points: points,
        coins: coins,
        xpProgress: 0.45,
        level: 3,
        onPointsUpdated: updatePoints,
        onCoinsUpdated: updateCoins,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userName: 'Sarah',
              level: 3,
              points: points,
              coins: coins,
              lessonsCompleted: 6,
              quizzesCompleted: 4,
              achievements: const [
                '5-Day Streak',
                '100% Quiz',
                'First Lesson Completed',
              ],
            ),
          );
        }

        if (settings.name == '/store') {
          return MaterialPageRoute(
            builder: (context) => StoreScreen(
              userName: 'Sarah',
              points: points,
              coins: coins,
              onPointsUpdated: updatePoints,
              onCoinsUpdated: updateCoins,
            ),
          );
        }

        if (settings.name == '/buy') {
          return MaterialPageRoute(
            builder: (context) => BuyCoinsScreen(
              onCoinsPurchased: updateCoins,
            ),
          );
        }

        if (settings.name == '/quiz') {
          return MaterialPageRoute(
            builder: (context) => QuizScreen(
              onPointsEarned: updatePoints,
            ),
          );
        }

        if (settings.name == '/quizEngine') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => QuizEngineScreen(
              category: args['category'],
              onPointsEarned: args['onPointsEarned'],
            ),
          );
        }

        return null;
      },
    );
  }
}
