import 'package:f1raceplatform/models/race_strategy.dart';
import 'package:f1raceplatform/services/strategy_calculator.dart';
import 'package:f1raceplatform/services/database_service.dart';
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
  double expectedTime = 0;
  bool isLoading = true;
  String? errorMessage;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculate();
    });
  }

  void _calculate() async {
    try {
      final s = widget.strategy;

      final sim = RaceDataPrep.calculateRaceTime(
        gp: s.gp,
        tires: s.tires,
        startCompound: s.startTyre,
        pitTyres: s.pitTyres,
        pitLaps: s.pitLaps,
      );

      final db = DatabaseService.instance;
      final expectedFromDb = await db.getExpectedTime(
        s.driverId,
        s.gpId,
      );

      final expected =
          expectedFromDb > 0 ? expectedFromDb : sim * 0.98;

      setState(() {
        totalTime = sim;
        expectedTime = expected;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  String formatTime(double seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    final secs = (seconds % 60).toStringAsFixed(2);

    if (hours > 0) {
      return "$hours:${minutes.toString().padLeft(2, '0')}:${secs.padLeft(5, '0')}";
    }
    return "${minutes}m ${secs}s";
  }

  // ---------------- UI HELPERS ----------------

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _actionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageWithFallback(
    String imageUrl,
    double height,
    String fallbackLabel,
  ) {
    if (imageUrl.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            fallbackLabel,
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0B0B0F),
                Color(0xFF141420),
                Color(0xFF0B0B0F),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : errorMessage != null
                      ? Text(errorMessage!,
                          style: const TextStyle(color: Colors.red))
                      : _buildResultsWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsWidget() {
    final diff = totalTime - expectedTime;
    final absDiff = diff.abs();

    final gpName = widget.strategy.gp['grandprix_name'] ?? 'Unknown';
    final driverFirstName =
        widget.strategy.driver['driver_first_name'] ?? 'Unknown';

    final gpImageUrl = gpImages[gpName] ?? '';
    final driverImageUrl = gpDrivers[driverFirstName] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// GP
          _glassCard(
            child: Column(
              children: [
                _buildImageWithFallback(gpImageUrl, 180, gpName),
                const SizedBox(height: 10),
                Text(
                  gpName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// DRIVER
          _glassCard(
            child: Column(
              children: [
                _buildImageWithFallback(driverImageUrl, 140, driverFirstName),
                const SizedBox(height: 10),
                Text(
                  "${widget.strategy.driver['driver_first_name']} ${widget.strategy.driver['driver_last_name']}".toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

      
          _glassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("YOUR TIME",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),
                    Text(
                      formatTime(totalTime),
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("VS",
                      style: TextStyle(color: Colors.white)),
                ),

                Column(
                  children: [
                    const Text("AI TIME",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),
                    Text(
                      formatTime(expectedTime),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _glassCard(
            child: Container(
              width: double.infinity,
              child: Column(
                
                children: [
                  Text(
                    diff < 0 ? "YOU WIN" : "YOU LOSE",
                    style: TextStyle(
                      color: diff < 0 ? Colors.greenAccent : Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${diff > 0 ? '+' : '-'}${absDiff.toStringAsFixed(2)}s",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: diff < 0 ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "DIFFERENCE TO AI",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// STRATEGY
          _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("STRATEGY",
                    style: TextStyle(color: Color(0xFFFFD700))),
                const SizedBox(height: 10),
                _buildDetailRow("Pit Stops",
                    widget.strategy.pitStops.toString()),
                _buildDetailRow("Start Tyre", widget.strategy.startTyre),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  text: "HOME",
                  color: Colors.grey.shade800,
                  onTap: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  text: "BACK",
                  color: const Color(0xFFB33731),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}