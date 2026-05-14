import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int totalquestions;
  final int correctanswer;
  final double persentagescore;
  final Color totalQuestionColor;
  final Color correctAnswerColor;

  ResultPage({
    required this.totalquestions,
    required this.correctanswer,
    required this.persentagescore,
    required this.totalQuestionColor,
    required this.correctAnswerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 24, 75),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("CONGRATS!", style: TextStyle(fontSize: 10)),
                SizedBox(height: 10),
                Text(
                  '${persentagescore.toStringAsFixed(2)}%score',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Quiz Completed Successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You attempted $totalquestions questions.',
                  style: TextStyle(fontSize: 18, color: totalQuestionColor),
                ),
                Text(
                  '$correctanswer answers are correct.',
                  style: TextStyle(fontSize: 18, color: correctAnswerColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          MaterialButton(
            onPressed: () {
              if (persentagescore < 50) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            },child: Text(
              persentagescore < 50 ? 'Try Again..!' : 'Back..!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            height: 75,
            minWidth: 180,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),color:persentagescore < 50 ? Colors.red :Colors.green ,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
