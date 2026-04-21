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
    
    print('=== STRATEGY ===');
    print('GP: ${s.gp['grandprix_name']}');
    print('Laps: ${s.gp['laps']}');
    print('Driver: ${s.driver['driver_first_name']}');
    print('Start Tyre: ${s.startTyre}');
    print('Pit Stops: ${s.pitStops}');
    print('Pit Laps: ${s.pitLaps}');
    print('Pit Tyres: ${s.pitTyres}');
    
    // SIM
    final sim = RaceDataPrep.calculateRaceTime(
      gp: s.gp,
      tires: s.tires,
      startCompound: s.startTyre,
      pitTyres: s.pitTyres,
      pitLaps: s.pitLaps,
    );
    
   
    
    // DB
    final db = DatabaseService.instance;
    final expectedFromDb = await db.getExpectedTime(
      s.driverId,
      s.gpId,
    );
    
   
    
  
    final expected = expectedFromDb > 0
        ? expectedFromDb
        : sim * 0.98;
    
    
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
    try {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      final secs = (seconds % 60).toStringAsFixed(2);

      if (hours > 0) {
        return "$hours:${minutes.toString().padLeft(2, '0')}:${secs.padLeft(5, '0')}";
      }
      return "${minutes}m ${secs}s";
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildImageWithFallback(
    String imageUrl,
    double height,
    String fallbackLabel,
  ) {
    if (imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade800,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image, size: 40, color: Colors.white38),
              const SizedBox(height: 8),
              Text(
                fallbackLabel,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade800,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 40, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade800,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : errorMessage != null
                  ? _buildErrorWidget()
                  : _buildResultsWidget(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 24),
          const Text(
            'Calculation Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage ?? 'Unknown error',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
             
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  ),
                  child: const Text(
                    'HOME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 179, 55, 51),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'BACK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsWidget() {
    final diff = totalTime - expectedTime;
    final absDiff = diff.abs();

    final gpName = widget.strategy.gp['grandprix_name'] as String? ?? 'Unknown';
    final driverFirstName =
        widget.strategy.driver['driver_first_name'] as String? ?? 'Unknown';
    final gpImageUrl = gpImages[gpName] ?? '';
    final driverImageUrl = gpDrivers[driverFirstName] ?? '';

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildImageWithFallback(gpImageUrl, 200, gpName),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildImageWithFallback(driverImageUrl, 150, driverFirstName),
          ),

          const SizedBox(height: 40),

          Text(
            'Your Simulation',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatTime(totalTime),
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 215, 0),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Expected Time (AI Baseline)',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatTime(expectedTime),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: diff < 0
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                border: Border.all(
                  color: diff < 0 ? Colors.green : Colors.red,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    diff < 0 ? '🚀 YOU WIN!' : '⚠️ YOU LOSE',
                    style: TextStyle(
                      color: diff < 0 ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    diff < 0
                        ? '−${absDiff.toStringAsFixed(2)}s'
                        : '+${absDiff.toStringAsFixed(2)}s',
                    style: TextStyle(
                      color: diff < 0 ? Colors.green : Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'vs. AI Baseline',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR STRATEGY',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Grand Prix:', gpName),
                  _buildDetailRow(
                    'Driver:',
                    '${widget.strategy.driver['driver_first_name']} ${widget.strategy.driver['driver_last_name']}',
                  ),
                  _buildDetailRow('Start Tyre:', widget.strategy.startTyre),
                  _buildDetailRow(
                    'Pit Stops:',
                    widget.strategy.pitStops.toString(),
                  ),
                  if (widget.strategy.pitStops > 0) ...[
                    _buildDetailRow(
                      'Pit Laps:',
                      widget.strategy.pitLaps.join(', '),
                    ),
                    _buildDetailRow(
                      'Pit Tyres:',
                      widget.strategy.pitTyres.join(', '),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ),
                    child: const Text(
                      'HOME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 179, 55, 51),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'BACK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
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
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
