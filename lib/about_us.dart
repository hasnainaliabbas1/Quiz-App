import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us',textAlign: TextAlign.center,),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This app is developed by Hasnain Ali Abbas. My aim to provide the best quizzes and knowledge-sharing platform. '
                  'My mission is to make learning fun and engaging for everyone.',
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
        child:Text('Back')
      ),
    );
  }
}
