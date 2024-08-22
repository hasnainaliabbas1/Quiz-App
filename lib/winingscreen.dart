import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/question.dart';

class Win extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;

  Win({required this.totalQuestions, required this.correctAnswers});

  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    initController();
    confettiController.play();
  }

  void initController() {
    confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/win.png"), fit: BoxFit.cover)),
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
          ),
          child: Text(
            "Share with Friends",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {},
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "CONGRATULATIONS!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Your Answers is Correct",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Correct Answers",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${widget.correctAnswers} out of ${widget.totalQuestions}",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Question(
                            quizId: 'nextQuizId',
                            queMoney: 0 // Update this according to your logic
                        )),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text("Next Quiz"),
                  )
                ],
              ),
            ),
            buildConfettiWidget(confettiController, pi / 2)
          ],
        ),
      ),
    );
  }

  Align buildConfettiWidget(ConfettiController controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        confettiController: controller,
        shouldLoop: false,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 20,
        minBlastForce: 8,
        emissionFrequency: 0.02,
        numberOfParticles: 30,
        gravity: 0.01,
      ),
    );
  }
}
