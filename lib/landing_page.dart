import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          EachPage("VongChong", 'assets/lotties/animation1.json'),
          EachPage("VongChong", 'assets/lotties/animation2.json'),
          EachPage("VongChong", 'assets/lotties/animation3.json'),
        ],
      ),
    );
  }
}

class EachPage extends StatelessWidget {
  final String tagLine;
  final String imgPath;

  const EachPage(this.tagLine, this.imgPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(imgPath),
            Text(
              tagLine,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.amberAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
