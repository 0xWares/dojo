import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(color: Colors.blueAccent),
          Container(color: Colors.deepOrange),
          Container(color: Colors.green),
        ],
      ),
    );
  }
}
