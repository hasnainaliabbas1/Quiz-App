import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class HowToUseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Use',textAlign: TextAlign.center,),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Use the App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. Navigate through the menu to explore different features.\n'
                  '2. Take daily quizzes to improve your knowledge.\n'
                  '3. Check the leaderboard to see your rank.\n'
                  '4. Visit the About Us section to know more about us.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        backgroundColor: Colors.purple[200],
        child: Text('Back')
      ),
    );
  }
}
