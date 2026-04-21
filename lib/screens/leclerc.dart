import 'dart:ui';
import 'package:flutter/material.dart';

class LeclercScreen extends StatefulWidget {
  const LeclercScreen({super.key});

  @override
  State<LeclercScreen> createState() => _LeclercScreenState();
}

class _LeclercScreenState extends State<LeclercScreen> {
  // 🏎️ CHARLES LECLERC STATS
  final String name = "Charles Leclerc";
  final String team = "Ferrari";
  final int wins = 5;
  final int podiums = 30;
  final int points = 1100;
  final int championships = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/lec.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  // ROW 1
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _glassBox("WINS", wins.toString()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _glassBox("PODIUMS", podiums.toString()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ROW 2
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _glassBox("POINTS", points.toString()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _glassBox("TEAM", team),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ROW 3
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _glassBox(
                            "CHAMPIONSHIPS",
                            championships.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // 🔊 BEST RADIO BOX (REPLACED IMAGE)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity(0.08),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "BEST RADIO",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "I AM STUPID",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassBox(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}