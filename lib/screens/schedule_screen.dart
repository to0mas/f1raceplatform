import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:f1raceplatform/theme/theme_data.dart';
import 'package:gradient_generator/gradient_generator.dart';
import 'package:f1raceplatform/screens/race_detail.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final List<F1Race> races = [
    F1Race(
      round: 1,
      gpName: "Australian Grand Prix",
      circuit: "Albert Park",
      country: "Australia",
      date: "6 - 8 March 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Australian_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 2,
      gpName: "Chinese Grand Prix",
      circuit: "Shanghai International",
      country: "China",
      date: "13 - 15 March 2026",
      isSprint: true,
      backgroundImage: 'assets/images/Chinese_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "2004",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 3,
      gpName: "Japanese Grand Prix",
      circuit: "Suzuka",
      country: "Japan",
      date: "27 - 29 March 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Japanese_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 4,
      gpName: "Bahrain Grand Prix",
      circuit: "Sakhir",
      country: "Bahrain",
      date: "10 - 12 April 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Bahrain_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 5,
      gpName: "Saudi Arabian Grand Prix",
      circuit: "Jeddah",
      country: "Saudi Arabia",
      date: "17 - 19 April 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Saudi_Arabian_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 6,
      gpName: "Miami Grand Prix",
      circuit: "Miami International",
      country: "USA",
      date: "1 - 3 May 2026",
      isSprint: true,
      backgroundImage: 'assets/images/Miami_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 7,
      gpName: "Canadian Grand Prix",
      circuit: "Gilles Villeneuve",
      country: "Canada",
      date: "22 - 24 May 2026",
      isSprint: true,
      backgroundImage: 'assets/images/Canadian_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 8,
      gpName: "Monaco Grand Prix",
      circuit: "Monte Carlo",
      country: "Monaco",
      date: "5 - 7 June 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Monaco_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 9,
      gpName: "Spanish Grand Prix",
      circuit: "Barcelona-Catalunya",
      country: "Spain",
      date: "12 - 14 June 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Spanish_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 10,
      gpName: "Austrian Grand Prix",
      circuit: "Red Bull Ring",
      country: "Austria",
      date: "26 - 28 June 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Austrian_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 11,
      gpName: "British Grand Prix",
      circuit: "Silverstone",
      country: "Great Britain",
      date: "3 - 5 July 2026",
      isSprint: true,
      backgroundImage: 'assets/images/British_Grand_Prix.png',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 12,
      gpName: "Belgian Grand Prix",
      circuit: "Spa-Francorchamps",
      country: "Belgium",
      date: "17 - 19 July 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Belgian_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
    F1Race(
      round: 13,
      gpName: "Hungarian Grand Prix",
      circuit: "Hungaroring",
      country: "Hungary",
      date: "17 - 19 July 2026",
      isSprint: false,
      backgroundImage: 'assets/images/Hungarian_Grand_Prix.jpg',
      circuitLength: "5.278 km",
      firstGP: "1996",
      fastestLap: "1:20.235 - Charles Leclerc (2022)",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GradientContainer(
              gradient: GradientX.linear(
                colors: [
                  const Color.fromARGB(82, 197, 11, 11),
                  Colors.black,
                ],
                angle: -360,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: races.length,
              itemBuilder: (context, index) {
                final race = races[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RaceDetail(race: race),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(race.backgroundImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: const Color(0xFF1A1A1A).withOpacity(0.55),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 197, 11, 11)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "R${race.round}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      race.gpName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${race.circuit} • ${race.country}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.75),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      race.date,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  if (race.isSprint)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "SPRINT",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white.withOpacity(0.6),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class F1Race {
  final int round;
  final String gpName;
  final String circuit;
  final String country;
  final String date;
  final bool isSprint;
  final String backgroundImage;
  final String circuitLength;
  final String firstGP;
  final String fastestLap;

  F1Race({
    required this.round,
    required this.gpName,
    required this.circuit,
    required this.country,
    required this.date,
    required this.isSprint,
    required this.backgroundImage,
    required this.circuitLength,
    required this.firstGP,
    required this.fastestLap,
  });
}