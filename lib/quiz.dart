import 'package:flutter/material.dart';
import 'package:quizapp/qlist.dart';
import 'package:quizapp/result.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:async';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late PageController pageview;
  late List<String?> userAns;
  int currentIndex = 0;

  // Timer
  Timer? _timer;
  int _remainingSeconds = 15;
  final int _totalSeconds = 15;

  @override
  void initState() {
    super.initState();
    pageview = PageController();
    userAns = List.filled(quizlist.length, null);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageview.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = _totalSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          if (userAns[currentIndex] == null) {
            userAns[currentIndex] = "__TIMEOUT__";
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),

          SafeArea(
            child: Column(
              children: [
                // Header bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Question counter badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0x14FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x1FFFFFFF)),
                        ),
                        child: Text(
                          "${currentIndex + 1} / ${quizlist.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      // Title
                      const Text(
                        "COSMIC QUIZ",
                        style: TextStyle(
                          color: Color(0xB3FFFFFF),
                          fontSize: 13,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Circular timer
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 44,
                            height: 44,
                            child: CircularProgressIndicator(
                              value: _remainingSeconds / _totalSeconds,
                              strokeWidth: 3.5,
                              backgroundColor: const Color(0x1AFFFFFF),
                              color: _remainingSeconds > 5
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                          ),
                          Text(
                            "$_remainingSeconds",
                            style: TextStyle(
                              color: _remainingSeconds > 5
                                  ? Colors.white
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / quizlist.length,
                      backgroundColor: const Color(0x1AFFFFFF),
                      color: const Color(0xFF7B2FBE),
                      minHeight: 5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: PageView.builder(
                    controller: pageview,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => currentIndex = index);
                      _startTimer();
                    },
                    itemCount: quizlist.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          children: [
                            // Question card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 28),
                                  decoration: BoxDecoration(
                                    color: const Color(0x0FFFFFFF),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0x1FFFFFFF),
                                    ),
                                  ),
                                  child: Text(
                                    quizlist[index]['question'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),

                            const SizedBox(height: 28),

                            // Time's up banner
                            if (userAns[index] == "__TIMEOUT__")
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0x26FF4444),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0x66FF4444)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_off,
                                        color: Colors.redAccent, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Time's up! See correct answer below.",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().shake(),

                            // Options
                            ...List.generate(
                                quizlist[index]['options'].length, (optionIndex) {
                              final String option =
                                  quizlist[index]['options'][optionIndex];
                              final bool isAnswered = userAns[index] != null;
                              final bool isSelected = userAns[index] == option;
                              final bool isCorrect =
                                  quizlist[index]['correctanswer'] == option;

                              Color borderColor = const Color(0x1FFFFFFF);
                              LinearGradient bgGradient = const LinearGradient(
                                colors: [Color(0x0DFFFFFF), Color(0x0DFFFFFF)],
                              );
                              IconData? trailingIcon;

                              if (isAnswered) {
                                if (isCorrect) {
                                  bgGradient = const LinearGradient(
                                    colors: [
                                      Color(0xFF11998E),
                                      Color(0xFF38EF7D)
                                    ],
                                  );
                                  borderColor = Colors.greenAccent;
                                  trailingIcon = Icons.check_circle_rounded;
                                } else if (isSelected) {
                                  bgGradient = const LinearGradient(
                                    colors: [
                                      Color(0xFFFF416C),
                                      Color(0xFFFF4B2B)
                                    ],
                                  );
                                  borderColor = Colors.redAccent;
                                  trailingIcon = Icons.cancel_rounded;
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: GestureDetector(
                                  onTap: isAnswered
                                      ? null
                                      : () {
                                          _timer?.cancel();
                                          setState(() {
                                            userAns[index] = option;
                                          });
                                        },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOut,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      gradient: bgGradient,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: borderColor, width: 1.5),
                                      boxShadow: isSelected ||
                                              (isAnswered && isCorrect)
                                          ? [
                                              BoxShadow(
                                                color: (isCorrect
                                                        ? Colors.greenAccent
                                                        : Colors.redAccent)
                                                    .withAlpha(64),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 18),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0x1AFFFFFF),
                                          ),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(
                                                  65 + optionIndex),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        if (trailingIcon != null)
                                          Icon(trailingIcon,
                                              color: Colors.white, size: 20),
                                        const SizedBox(width: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(delay: (80 * optionIndex).ms).slideX(begin: 0.08);
                            }),

                            const SizedBox(height: 16),

                            // Next / Submit button
                            if (userAns[index] != null)
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (index < quizlist.length - 1) {
                                      pageview.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOutCubic,
                                      );
                                    } else {
                                      _showResult();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0F0C29),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    index < quizlist.length - 1
                                        ? "Next Question →"
                                        : "View Results 🏁",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn().scale(
                                  begin: const Offset(0.95, 0.95)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showResult() {
    int correct = 0;
    for (int i = 0; i < quizlist.length; i++) {
      if (userAns[i] == quizlist[i]['correctanswer']) correct++;
    }
    final double percentage = (correct / quizlist.length) * 100;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalquestions: quizlist.length,
          correctanswer: correct,
          persentagescore: percentage,
        ),
      ),
    );
  }
}
