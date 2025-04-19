import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final int level;
  final int points;
  final int coins;
  final int lessonsCompleted;
  final int quizzesCompleted;
  final List<String> achievements; // e.g., ['5-Day Streak', '100% Quiz']

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.level,
    required this.points,
    required this.coins,
    required this.lessonsCompleted,
    required this.quizzesCompleted,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Avatar & Name
            Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Level $level',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),

            // Points and Coins
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statTile('Points', points.toString(), Icons.star),
                _statTile('Coins', coins.toString(), Icons.monetization_on),
              ],
            ),

            const SizedBox(height: 24),

            // Progress
            Text('Progress', style: GoogleFonts.poppins(fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statTile('Lessons', lessonsCompleted.toString(), Icons.menu_book),
                _statTile('Quizzes', quizzesCompleted.toString(), Icons.quiz),
              ],
            ),

            const SizedBox(height: 24),

            // Achievements
            Text('Achievements', style: GoogleFonts.poppins(fontSize: 18)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: achievements.map((title) => Chip(
                label: Text(title),
                avatar: const Icon(Icons.emoji_events, size: 16),
                backgroundColor: Colors.teal.shade50,
              )).toList(),
            ),

            const SizedBox(height: 30),

            // Back to Home
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Home"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal, size: 30),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(label, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }
}
