import 'package:flutter/material.dart';
import 'package:quizapp/qlist.dart';
import 'package:quizapp/result.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late PageController pageview;
  late List<String?> userAns;
  @override
  void initState() {
    super.initState();
    pageview = PageController();
    userAns = List.filled(quizlist.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageview,
        itemCount: quizlist.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 105, 99, 99),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      quizlist[index]['question'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: List.generate(quizlist[index]['options'].length, (
                      optionIndex,
                    ) {
                      String option = quizlist[index]['options'][optionIndex];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            userAns[index] = option;
                          });
                        },
                        child: Container(
                          height: 45,
                          width: 300,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                            color: _getOptionColor(option, index),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      if (index < quizlist.length - 1) {
                        pageview.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.ease,
                        );
                      } else {
                        showResult();
                      }
                    },
                    child: Text(
                      index < quizlist.length - 1 ? "Next" : "Submit",
                      style: TextStyle(fontSize: 18),
                    ),

                    textColor: Colors.black87,
                    height: 65,
                    minWidth: 140,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getOptionColor(String option, int index) {
    if (userAns[index] != null) {
      if (quizlist[index]['correctanswer'] == option) {
        return Colors.green;
      } else if (userAns[index] == option) {
        return Colors.red;
      } else {
        return Colors.transparent;
      }
    }
    return Colors.transparent;
  }

  void showResult() {
    int totalQuestions = quizlist.length;
    int correctanswer = 0;

    for (int i = 0; i < totalQuestions; i++) {
      if (userAns[i] == quizlist[i]['correctanswer']) {
        correctanswer++;
      }
    }
    double percentagescore = (correctanswer / totalQuestions) * 100;
    Color totalQuestionColor = Colors.red;
    Color correctAnswerColor = Colors.green;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          totalquestions: totalQuestions,
          correctanswer: correctanswer,
          persentagescore: percentagescore,
          totalQuestionColor: totalQuestionColor,
          correctAnswerColor: correctAnswerColor,
        ),
      ),
    );
  }
}
