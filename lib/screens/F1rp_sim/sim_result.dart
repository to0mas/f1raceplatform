import 'package:f1raceplatform/models/race_strategy.dart';
import 'package:f1raceplatform/services/strategy_calculator.dart';
import 'package:flutter/material.dart';

class FinalResult extends StatefulWidget {
  const FinalResult({
    super.key,
    required this.strategy,
  });

  final RaceStrategy strategy;

  @override
  State<FinalResult> createState() => _FinalResultState();
}

class _FinalResultState extends State<FinalResult> {
  double totalTime = 0;     // SIMULATION TIME
  double dbTotalTime = 0;   // DATABASE TIME
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateResult();
    });
  }

  void _calculateResult() {
    final s = widget.strategy;

    final resultTime = RaceDataPrep.calculateRaceTime(
      gp: s.gp,
      tires: s.tires,
      startCompound: s.startTyre,
      pitTyres: s.pitTyres,
      pitLaps: s.pitLaps,
    );

    final dbTime = RaceDataPrep.getBaseLapTime(s.gp) *
        (s.gp['laps'] ?? 50); 

    setState(() {
      totalTime = resultTime;
      dbTotalTime = dbTime;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gpName = widget.strategy.gp['grandprix_name'];
    final driverName = widget.strategy.driver['driver_first_name'];

    final diff = totalTime - dbTotalTime;
    final isFaster = diff < 0;

    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // SIM TIME
                  Text(
                    "${totalTime.toStringAsFixed(2)} s",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DB TIME
                  Text(
                    "DB: ${dbTotalTime.toStringAsFixed(2)} s",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DIFFERENCE
                  Text(
                    isFaster
                        ? "${diff.toStringAsFixed(2)}s faster"
                        : "+${diff.abs().toStringAsFixed(2)}s slower",
                    style: TextStyle(
                      color: isFaster ? Colors.green : Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}