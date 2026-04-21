import 'dart:ui';
import 'package:flutter/material.dart';

class AlonsoScreen extends StatefulWidget {
  const AlonsoScreen({super.key});

  @override
  State<AlonsoScreen> createState() => _AlonsoScreenState();
}

class _AlonsoScreenState extends State<AlonsoScreen> {
  // 🏎️ FERNANDO ALONSO STATS
  final String name = "Fernando Alonso";
  final String team = "Aston Martin";
  final int wins = 32;
  final int podiums = 106;
  final int points = 2300;
  final int championships = 2;

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
              'assets/images/alo.png',
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

                        // 🔊 BEST RADIO BOX
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "IF YOU SPEAK TO ME EVERY LAP I WILL DISCONNECT THE RADIO",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
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