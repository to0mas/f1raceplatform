import 'package:f1raceplatform/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:f1raceplatform/theme/theme_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), (){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage())
      );
    });
  }


  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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

        )
    );
  }
}

