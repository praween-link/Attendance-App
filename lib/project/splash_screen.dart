import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);


  static const routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 18,
      fontWeight: FontWeight.w900,
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/gthlogo.png',
              width: 100,
              height: 100,
              scale: 1.0,
            ),
            const SizedBox(height: 35.0),
            // ignore: deprecated_member_use
            TyperAnimatedTextKit(
              text: const ["GEETA TECHNICAL HUB"],
              textStyle: textStyle,
              speed: const Duration(milliseconds: 100),
            ),
          ],
        ),
      ),
    );
  }
}
