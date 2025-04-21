import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'LoginScreen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'store_screen.dart';
import 'buy_screen.dart';
import 'quiz_screen.dart';
import 'quiz_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FinEduApp());
}

class FinEduApp extends StatefulWidget {
  const FinEduApp({super.key});

  @override
  State<FinEduApp> createState() => _FinEduAppState();
}

class _FinEduAppState extends State<FinEduApp> {
  int points = 0;
  int coins = 0;
  int level = 1;
  double xpProgress = 0.0;
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserData(user.uid);
      } else {
        setState(() => isLoading = false);
      }
    });
  }

  Future<void> fetchUserData(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          userName = data['name'] ?? 'User';
          points = data['points'] ?? 0;
          coins = data['coins'] ?? 0;
          level = data['level'] ?? 1;
          xpProgress = (data['xpProgress'] ?? 0).toDouble();
          isLoading = false;
        });
      } else {
        print('User document not found');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
      setState(() => isLoading = false);
    }
  }

  void updatePoints(int value) {
    setState(() => points += value);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'points': FieldValue.increment(value),
      });
    }
  }

  void updateCoins(int value) {
    setState(() => coins += value);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'coins': FieldValue.increment(value),
      });
    }
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
      initialRoute: '/',
      routes: {
        '/': (context) => isLoading
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : FirebaseAuth.instance.currentUser == null
                ? LoginScreen()
                : HomeScreen(
                    userName: userName,
                    points: points,
                    coins: coins,
                    xpProgress: xpProgress,
                    level: level,
                    onPointsUpdated: updatePoints,
                    onCoinsUpdated: updateCoins,
                  ),
        '/home': (context) => HomeScreen(
              userName: userName,
              points: points,
              coins: coins,
              xpProgress: xpProgress,
              level: level,
              onPointsUpdated: updatePoints,
              onCoinsUpdated: updateCoins,
            ),
        '/profile': (context) => ProfileScreen(
              userName: userName,
              level: level,
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
        '/store': (context) => StoreScreen(
              userName: userName,
              points: points,
              coins: coins,
              onPointsUpdated: updatePoints,
              onCoinsUpdated: updateCoins,
            ),
        '/buy': (context) => BuyCoinsScreen(
              onCoinsPurchased: updateCoins,
            ),
        '/quiz': (context) => QuizScreen(
              onPointsEarned: updatePoints,
            ),
      },
      onGenerateRoute: (settings) {
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
