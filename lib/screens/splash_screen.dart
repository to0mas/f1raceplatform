import 'package:f1raceplatform/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:f1raceplatform/theme/theme_data.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // fake loading progress
    Future.delayed(const Duration(milliseconds: 500), _startLoading);
  }

  void _startLoading() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 80));

      if (!mounted) return false;

      setState(() {
        progress += 0.02;
        if (progress > 1) progress = 1;
      });

      return progress < 1;
    }).then((_) {
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
      backgroundColor: appTheme.scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const Spacer(),

        
            Image.asset(
              'assets/images/Logo_tr.png',
              height: 250,
              width: 250,
            )
               .animate()
    .fadeIn(duration: 200.ms)
    .scale(
      begin: const Offset(0.0, 0.0),
      end: const Offset(1, 1),
      curve: Curves.elasticOut,
      duration: 800.ms,
    ),

            const SizedBox(height: 30),

            Image.asset(
              'assets/images/logo_sign.png',
              height: 200,
              width: 200,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slide(begin: const Offset(0, 0.3))
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1, 1),
                  curve: Curves.easeOut,
                  duration: 600.ms,
                ),

            const Spacer(),

           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFE8002D),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 10),

                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}