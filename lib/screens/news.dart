import 'dart:ui';

import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/api_calls/driver_standings_call.dart';
import 'package:f1raceplatform/api_calls/news_call.dart';
import 'package:f1raceplatform/models/driver.dart';
import 'package:f1raceplatform/models/driver_standing.dart';
import 'package:f1raceplatform/models/news.dart';
import 'package:f1raceplatform/screens/F1rp_sim/f1rp_sim.dart';
import 'package:f1raceplatform/screens/standings.dart';
import 'package:f1raceplatform/widgets/race_card.dart';
import 'package:flutter/material.dart';
import 'package:f1raceplatform/theme/theme_data.dart';
import 'package:gradient_generator/gradient_generator.dart';
import 'package:f1raceplatform/models/races.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


        
appBar: AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: Colors.transparent,
  elevation: 0,

  flexibleSpace: Padding(
    padding: const EdgeInsets.all(1.0),
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(111, 167, 51, 51).withOpacity(0.2), // glass efekt
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    ),
  ),

  title: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Center(
      child: Image.asset(
        'assets/images/Logo_tr_cerna.png',
        height: 50,
        width: 45,
      ),
    ),
  ),
),







    );
  }
}