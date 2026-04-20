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
  double totalTime = 0;
  double dbTotalTime = 0;

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

    setState(() {
      totalTime = resultTime;

      // DB time (zatím placeholder – pak napojíš DB)
      dbTotalTime = resultTime + 5.0; // simulace rozdílu

      isLoading = false;
    });
  }

  final Map<String, String> gpImages = {
    'Bahrain Grand Prix':
        'https://media.formula1.com/image/upload/c_lfill,w_2048/q_auto/v1740000001/content/dam/fom-website/manual/2023/BahrainGP/GettyImages-1471457958.webp',
    'Australian Grand Prix':
        'https://images.ctfassets.net/gy95mqeyjg28/2EkenT3S9x0YTd6UpW0vxT/4badbff144512a6efbf1838561187361/2265031100.jpg?w=3840&q=75&fm=webp&fit=fill',
    'Japanese Grand Prix':
        'https://media.formula1.com/image/upload/f_auto/q_auto/v1677245019/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Japan.jpg',
    'British Grand Prix':
        'https://media.formula1.com/image/upload/c_lfill,w_3392/q_auto/v1740000001/content/dam/fom-website/sutton/2021/GreatBritain/Sunday/1329376119.webp',
    'Italian Grand Prix':
        'https://media.formula1.com/image/upload/f_auto/q_auto/v1677238736/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Italy.jpg',
  };

  final Map<String, String> gpDrivers = {
    'Max':
        'https://gpticketstore.vshcdn.net/uploads/images/12172/teams-lineups-f1-max-verstapen.jpg',
    'Lando':
        'https://media.formula1.com/image/upload/t_16by9Centre/c_lfill,w_3392/q_auto/v1740000001/trackside-images/2024/F1_Grand_Prix_Of_Singapore/2173723984.webp',
    'Charles':
        'https://cd8.incdatagate.cz/images/1f12bb3a-944b-6418-b479-41c093038f50/720x405.jpg',
    'George':
        'https://cd8.incdatagate.cz/images/1f0717cf-1997-659c-89dd-c300895e78dd/720x405.jpg',
    'Fernando':
        'https://f1chronicle.com/wp-content/uploads/2023/11/GP2320_141541_ONZ8936-scaled.jpg',
  };

  @override
  Widget build(BuildContext context) {
    final gpName = widget.strategy.gp['grandprix_name'];
    final driverName = widget.strategy.driver['driver_first_name'];

    final diff = totalTime - dbTotalTime;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GP IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Image.network(
                            gpImages[gpName] ?? '',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Container(color: Colors.black.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DRIVER IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Image.network(
                            gpDrivers[driverName] ?? '',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Container(color: Colors.black.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TIMES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _timeBox(
                        "YOUR STRATEGY",
                        totalTime,
                        const Color.fromARGB(255, 179, 55, 51),
                      ),
                      const SizedBox(width: 16),
                      _timeBox(
                        "DB TIME",
                        dbTotalTime,
                        Colors.white,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // DIFFERENCE
                  Text(
                    diff > 0
                        ? "+${diff.toStringAsFixed(2)} s slower"
                        : "${diff.toStringAsFixed(2)} s faster",
                    style: TextStyle(
                      color: diff > 0 ? Colors.red : Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _timeBox(String label, double time, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            "${time.toStringAsFixed(2)} s",
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}