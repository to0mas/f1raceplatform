import 'package:f1raceplatform/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_generator/gradient_generator.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: GradientContainer(
  gradient: GradientX.radial(
     colors: [const Color.fromARGB(150, 197, 11, 11), Color(Color.fromARGB(255, 0, 0, 0).value)],
      radius: 1.0,
  ),
  child: SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              'assets/images/Logo_tr.png',
              height: 250,
              width: 250,
            ),
          ),
        ),
        Image.asset(
          'assets/images/logo_sign.png',
          height: 200,
          width: 200,
        ),
      ],
    ),
  ),
),
    );
  }
}