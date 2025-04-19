import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatelessWidget {
  final Function(int) onPointsEarned;

  const QuizScreen({
    super.key,
    required this.onPointsEarned,
  });

  @override
  Widget build(BuildContext context) {
    final quizCategories = [
      {
        'title': 'Budgeting Basics',
        'icon': Icons.account_balance_wallet,
        'progress': 0.6,
        'questions': 10,
      },
      {
        'title': 'Credit & Loans',
        'icon': Icons.credit_card,
        'progress': 0.3,
        'questions': 12,
      },
      {
        'title': 'Fraud Awareness',
        'icon': Icons.shield,
        'progress': 1.0,
        'questions': 8,
      },
      {
        'title': 'Banking Essentials',
        'icon': Icons.account_balance,
        'progress': 0.0,
        'questions': 15,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Quiz'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Test your knowledge across financial topics:',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quizCategories.length,
              itemBuilder: (context, index) {
                final category = quizCategories[index];
                final progress = category['progress'] as double;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.teal.shade50,
                              child: Icon(
                                category['icon'] as IconData,
                                size: 28,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category['title'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/quizEngine',
                                  arguments: {
                                    'category': category['title'],
                                    'onPointsEarned': onPointsEarned,
                                  },
                                );
                              },
                              child: const Text('Start'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progress == 1.0 ? Colors.green : Colors.teal,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(progress * 100).toInt()}% completed • ${category['questions']} Questions',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
