import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizEngineScreen extends StatefulWidget {
  final String category;
  final Function(int) onPointsEarned;

  const QuizEngineScreen({
    super.key,
    required this.category,
    required this.onPointsEarned,
  });

  @override
  State<QuizEngineScreen> createState() => _QuizEngineScreenState();
}

class _QuizEngineScreenState extends State<QuizEngineScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int coins = 3;
  bool showHint = false;
  bool quizCompleted = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the best way to start budgeting?',
      'options': ['Guess monthly expenses', 'Track income and expenses', 'Borrow monthly', 'Use a credit card'],
      'answer': 'Track income and expenses',
      'hint': 'It’s about understanding how money comes and goes.'
    },
    {
      'question': 'Which of these is NOT a type of loan?',
      'options': ['Auto loan', 'Student loan', 'Mortgage', 'Saving loan'],
      'answer': 'Saving loan',
      'hint': 'This one actually earns you money, not borrows.'
    },
    {
      'question': 'What’s a common sign of financial fraud?',
      'options': ['Job offer', 'Unexpected prize win', 'Utility bill', 'Bank alert'],
      'answer': 'Unexpected prize win',
      'hint': 'If it sounds too good to be true, it probably is.'
    },
  ];

  void selectAnswer(String selected) {
    if (quizCompleted) return;

    final correctAnswer = questions[currentQuestionIndex]['answer'];

    if (selected == correctAnswer) {
      score += 10;
    }

    if (currentQuestionIndex == questions.length - 1) {
      setState(() => quizCompleted = true);
      widget.onPointsEarned(score);
    } else {
      setState(() {
        currentQuestionIndex++;
        showHint = false;
      });
    }
  }

  void useHint() {
    if (coins > 0 && !showHint) {
      setState(() {
        coins--;
        showHint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.yellow),
                Text(coins.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: quizCompleted ? _buildResultScreen() : _buildQuestionCard(current),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${currentQuestionIndex + 1} of ${questions.length}',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Text(
          question['question'],
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          (question['options'] as List<String>).length,
              (i) => Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => selectAnswer(question['options'][i]),
              child: Text(question['options'][i]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: useHint,
          icon: const Icon(Icons.lightbulb),
          label: const Text('Hint'),
        ),
        if (showHint) ...[
          const SizedBox(height: 12),
          Text(
            '💡 ${question['hint']}',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.deepOrange),
          ),
        ]
      ],
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
          const SizedBox(height: 16),
          Text(
            'Quiz Completed!',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Your Score: $score',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Quizzes'),
          )
        ],
      ),
    );
  }
}
