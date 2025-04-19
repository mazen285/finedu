import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementScreen extends StatefulWidget {
  final int currentPoints;
  final Function(int) onPointsClaimed;

  const AchievementScreen({
    super.key,
    required this.currentPoints,
    required this.onPointsClaimed,
  });

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  late int userPoints;
  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'First Quiz Completed',
      'description': 'Finish your first quiz.',
      'points': 20,
      'achieved': true,
      'claimed': false,
    },
    {
      'title': '5-Day Login Streak',
      'description': 'Login 5 days in a row.',
      'points': 50,
      'achieved': true,
      'claimed': false,
    },
    {
      'title': 'Complete 10 Lessons',
      'description': 'Finish 10 learning modules.',
      'points': 100,
      'achieved': false,
      'claimed': false,
    },
    {
      'title': '100% Score on a Quiz',
      'description': 'Score perfect in any quiz.',
      'points': 30,
      'achieved': true,
      'claimed': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    userPoints = widget.currentPoints;
  }

  void claimReward(int index) {
    setState(() {
      achievements[index]['claimed'] = true;
      userPoints += (achievements[index]['points'] as int); // ✅ fix here
    });

    widget.onPointsClaimed(achievements[index]['points'] as int); // ✅ also fix here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🎉 You claimed ${achievements[index]['points']} points!")),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final isAchieved = achievement['achieved'] as bool;
          final isClaimed = achievement['claimed'] as bool;

          return Opacity(
            opacity: isAchieved ? 1.0 : 0.5,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(
                  isClaimed
                      ? Icons.emoji_events
                      : isAchieved
                      ? Icons.check_circle
                      : Icons.lock_outline,
                  color: isClaimed
                      ? Colors.orange
                      : isAchieved
                      ? Colors.green
                      : Colors.grey,
                  size: 32,
                ),
                title: Text(achievement['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: Text(achievement['description']),
                trailing: isAchieved && !isClaimed
                    ? ElevatedButton(
                  onPressed: () => claimReward(index),
                  child: const Text('Claim'),
                )
                    : isClaimed
                    ? const Text('Claimed', style: TextStyle(color: Colors.teal))
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
