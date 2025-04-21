import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'achievement_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final int points;
  final int coins;
  final double xpProgress; // range: 0.0 to 1.0
  final int level;
  final Function(int) onPointsUpdated;
  final Function(int) onCoinsUpdated;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.points,
    required this.coins,
    required this.xpProgress,
    required this.level,
    required this.onPointsUpdated,
    required this.onCoinsUpdated,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int points;
  late int coins;

  @override
  void initState() {
    super.initState();
    points = widget.points;
    coins = widget.coins;
  }

  void updatePoints(int earnedPoints) {
    setState(() => points += earnedPoints);
    widget.onPointsUpdated(earnedPoints);
  }

  void updateCoins(int earnedCoins) {
    setState(() => coins += earnedCoins);
    widget.onCoinsUpdated(earnedCoins);
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildXPProgressCard(),
              const SizedBox(height: 16),
              _buildStatRow(),
              const SizedBox(height: 20),
              _buildGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  widget.userName,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: const Icon(Icons.settings),
              tooltip: 'Profile',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildXPProgressCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.teal,
              child: Text(
                widget.level.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('XP Progress',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: widget.xpProgress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 4),
                  Text('${(widget.xpProgress * 100).toInt()}% to next level',
                      style: GoogleFonts.poppins(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('Points', points, Icons.star),
        _buildStatCard('Coins', coins, Icons.monetization_on),
      ],
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.teal, size: 28),
            const SizedBox(height: 8),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: value),
              duration: const Duration(milliseconds: 500),
              builder: (context, val, _) {
                return Text(
                  val.toString(),
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
            Text(label, style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        padding: const EdgeInsets.only(bottom: 10),
        children: [
          _buildGridItem(context,
              title: 'Lessons',
              icon: Icons.menu_book_rounded,
              route: '/lesson'),
          _buildGridItem(context,
              title: 'Quizzes', icon: Icons.quiz_rounded, route: '/quiz'),
          _buildGridItem(context,
              title: 'Store', icon: Icons.storefront, route: '/store'),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AchievementScreen(
                    currentPoints: points,
                    onPointsClaimed: (earned) => updatePoints(earned),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events, size: 36, color: Colors.teal),
                    const SizedBox(height: 10),
                    Text('Achievements',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context,
      {required String title, required IconData icon, required String route}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: Colors.teal),
              const SizedBox(height: 10),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
