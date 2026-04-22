import 'package:f1raceplatform/models/races.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:async';
import 'package:f1raceplatform/api_calls/races_call.dart';

class RaceCard extends StatefulWidget {
  const RaceCard({super.key});

  @override
  State<RaceCard> createState() => _RaceCardState();
}

class _RaceCardState extends State<RaceCard> {
  List<Race> races = [];
  bool isLoading = true;

 
  late Timer timer;
  Duration timeLeft = Duration.zero;
  final DateTime targetDate = DateTime(2026, 5, 1);

  @override
  void initState() {
    super.initState();
    loadRaces();
    startCountdown();
  }

  void loadRaces() async {
    try {
      final racesInfo = await RacesCall().getRace();

      setState(() {
        races = racesInfo;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final difference = targetDate.difference(now);

      setState(() {
        timeLeft = difference.isNegative ? Duration.zero : difference;
      });
    });
  }

  String formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE10600),
        ),
      );
    }

    if (races.isEmpty) {
      return const Center(
        child: Text(
          "No races found",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final race = races[0];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Animate(
            effects: [
              FadeEffect(duration: 600.ms),
              SlideEffect(
                begin: const Offset(0, 0.3),
                curve: Curves.easeOut,
                duration: 600.ms,
              ),
            ],
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.ctfassets.net/gy95mqeyjg28/5JNOmfnCQtENFZ17zbJv87/2064c97ebcd975946cbd0ee02064ae46/GP2406_152034_V6A3454.jpg?w=3840&q=75&fm=webp&fit=fill'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFE10600).withOpacity(0.25),
                              const Color(0xFF8B0000).withOpacity(0.15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE10600).withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NEXT RACE',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              race.raceName.toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    color: Color(0xFFFFD700),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    timeLeft.inSeconds == 0
                                        ? "MAY 1 IS HERE 🚀"
                                        : formatDuration(timeLeft),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Animate(
                  delay: 100.ms,
                  effects: [
                    FadeEffect(duration: 600.ms),
                    SlideEffect(
                      begin: const Offset(-0.2, 0),
                      curve: Curves.easeOut,
                      duration: 600.ms,
                    ),
                  ],
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFE10600).withOpacity(0.2),
                          const Color(0xFF8B0000).withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFFE10600).withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE10600).withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            race.laps.toString(),
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'LAPS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Animate(
                  delay: 200.ms,
                  effects: [
                    FadeEffect(duration: 600.ms),
                    SlideEffect(
                      begin: const Offset(0.2, 0),
                      curve: Curves.easeOut,
                      duration: 600.ms,
                    ),
                  ],
                  child: Container(
                    height: 120,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            race.corners.toString(),
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'CORNERS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
