import 'package:flutter/material.dart';
import 'buy_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'store_screen.dart';


void main() {
  runApp(const FinEduApp());
}

class FinEduApp extends StatelessWidget {
  const FinEduApp({super.key});

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
      home: const HomeScreen(
        userName: 'Sarah',
        points: 120,
        coins: 35,
        xpProgress: 0.45,
        level: 3,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => const ProfileScreen(
              userName: 'Sarah',
              level: 3,
              points: 120,
              coins: 35,
              lessonsCompleted: 6,
              quizzesCompleted: 4,
              achievements: [
                '5-Day Streak',
                '100% Quiz',
                'First Lesson Completed',
              ],
            ),
          );
        }

        if (settings.name == '/store') {
          return MaterialPageRoute(
            builder: (context) => const StoreScreen(
              userName: 'Sarah',
              points: 120,
              coins: 35,
            ),
          );
        }

        if (settings.name == '/buy') {
          return MaterialPageRoute(
            builder: (context) => const BuyCoinsScreen(),
          );
        }

        return null;
      },
    );
  }
}
