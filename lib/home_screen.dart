import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final int points;
  final int coins;
  final double xpProgress; // range: 0.0 to 1.0
  final int level;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.points,
    required this.coins,
    required this.xpProgress,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + Welcome
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Welcome, $userName!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // XP Progress + Level
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Level $level',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: xpProgress,
                        backgroundColor: Colors.grey[300],
                        color: Colors.teal,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 4),
                      Text('${(xpProgress * 100).toInt()}% to next level',
                          style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Points & Coins
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Points', points.toString(), Icons.star),
                  _buildStatCard('Coins', coins.toString(), Icons.monetization_on),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Action Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: const EdgeInsets.only(bottom: 10),
                  children: [
                    _buildGridItem(
                      context,
                      title: 'Lessons',
                      icon: Icons.menu_book_rounded,
                      route: '/lesson',
                    ),
                    _buildGridItem(
                      context,
                      title: 'Quizzes',
                      icon: Icons.quiz_rounded,
                      route: '/quiz',
                    ),
                    _buildGridItem(
                      context,
                      title: 'Store',
                      icon: Icons.storefront,
                      route: '/store',
                    ),
                    _buildGridItem(
                      context,
                      title: 'Profile',
                      icon: Icons.person,
                      route: '/profile',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.teal, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
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
