import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quizapp/quiz.dart';

class ResultPage extends StatelessWidget {
  final int totalquestions;
  final int correctanswer;
  final double persentagescore;

  const ResultPage({
    super.key,
    required this.totalquestions,
    required this.correctanswer,
    required this.persentagescore,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPassed = persentagescore >= 50;
    final int wrong = totalquestions - correctanswer;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header label
              Text(
                isPassed ? "🎉 CONGRATULATIONS!" : "💪 GOOD EFFORT!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn().slideY(begin: -0.2),

              const SizedBox(height: 10),

              Text(
                isPassed
                    ? "You passed the quiz!"
                    : "Keep practicing and try again.",
                style: const TextStyle(
                  color: Color(0x99FFFFFF),
                  fontSize: 14,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 48),

              // Circular score
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: persentagescore / 100,
                      strokeWidth: 10,
                      backgroundColor: const Color(0x1AFFFFFF),
                      color: isPassed ? Colors.greenAccent : Colors.orangeAccent,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${persentagescore.toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "SCORE",
                        style: TextStyle(
                          color: Color(0x80FFFFFF),
                          fontSize: 13,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 48),

              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0x0DFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x1FFFFFFF)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(
                          "Total", totalquestions.toString(), Colors.white70),
                      _divider(),
                      _statItem(
                          "Correct", correctanswer.toString(), Colors.greenAccent),
                      _divider(),
                      _statItem("Wrong", wrong.toString(), Colors.redAccent),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),

              const SizedBox(height: 48),

              // Play Again button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Quiz()),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Play Again"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F0C29),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0x80FFFFFF), fontSize: 13),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0x1FFFFFFF),
    );
  }
}
