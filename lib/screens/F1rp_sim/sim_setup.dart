import 'dart:ui';
import 'package:f1raceplatform/models/race_strategy.dart';
import 'package:f1raceplatform/screens/F1rp_sim/sim_result.dart';
import 'package:f1raceplatform/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SimSetup extends StatefulWidget {
  const SimSetup({super.key});

  @override
  State<SimSetup> createState() => _SimSetupState();
}

class _SimSetupState extends State<SimSetup> {
  int currenStep = 0;

  List<Map<String, dynamic>> grandPrixList = [];
  List<Map<String, dynamic>> driverList = [];
  List<Map<String, dynamic>> tireList = [];

  int pitStops = 0;
  List<int?> pitLaps = [];
  List<String?> pitTireNames = [];

  String? pitValidationError;

  final Map<String, String> gpTyres = {
    'Soft':
        'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/red-parentesi.png',
    'Medium':
        'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/yellow-parentesi.png',
    'Hard':
        'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/white-parentesi.png',
    'Intermediate':
        'https://tyre-assets.pirelli.com/images/global/380/862/cinturato-green-intermediate-4505508953587.png',
    'Full Wet':
        'https://tyre-assets.pirelli.com/images/global/968/233/cinturato-blue-wet-4505508953865.png',
  };

  final Map<String, String> gpImages = {
    'Bahrain Grand Prix':
        'https://media-cldnry.s-nbcnews.com/image/upload/rockcms/2026-03/260303-formula-1-testing-ew-600p-a3c0cd.jpg',
    'Australian Grand Prix':
        'https://images.ps-aws.com/c?url=https%3A%2F%2Fd3cm515ijfiu6w.cloudfront.net%2Fwp-content%2Fuploads%2F2025%2F03%2F16052041%2F2025-australian-grand-prix-race-start-1320x742.jpg',
    'Japanese Grand Prix':
        'https://media.formula1.com/image/upload/f_auto/q_auto/v1677245019/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Japan.jpg',
    'British Grand Prix':
        'https://www.motorsportmagazine.com/wp-content/uploads/2025/07/20240707F1-0257-800x450.jpg',
    'Italian Grand Prix':
        'https://media.formula1.com/image/upload/f_auto/q_auto/v1677238736/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Italy.jpg',
  };

  final Map<String, String> gpDrivers = {
    'Max':
        'https://gpticketstore.vshcdn.net/uploads/images/12172/teams-lineups-f1-max-verstapen.jpg',
    'Lando':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMCaxQYbMkkwnaJKzG0GsO63SaDaI_bu8gMw&s',
    'Charles':
        'https://cd8.incdatagate.cz/images/1f12bb3a-944b-6418-b479-41c093038f50/720x405.jpg',
    'George':
        'https://cd8.incdatagate.cz/images/1f0717cf-1997-659c-89dd-c300895e78dd/720x405.jpg',
    'Fernando':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBQt6hcI2AvnV4TMYZcKXZDN-s7qqrCI0EvA&s',
  };

  Map<String, dynamic>? selectedGP;
  Map<String, dynamic>? selectedDriver;
  Map<String, dynamic>? selectedStart;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final db = await DatabaseService.instance.getDatabase();
      final gp = await db.query('grandprix');
      final drivers = await db.query('drivers');
      final tires = await db.query('tires');

      setState(() {
        grandPrixList = gp;
        driverList = drivers;
        tireList = tires;
      });
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  String? validatePitStops() {
    if (pitStops == 0) return null;

    final cleanLaps = pitLaps.whereType<int>().toList();
    final cleanTyres = pitTireNames.whereType<String>().toList();

    if (cleanLaps.length != pitStops || cleanTyres.length != pitStops) {
      return 'All pit stops must be configured';
    }

    final totalLaps = selectedGP?['laps'] as int? ?? 57;


    for (int i = 0; i < cleanLaps.length - 1; i++) {
      if (cleanLaps[i] >= cleanLaps[i + 1]) {
        return 'Pit stops must be in ascending order (Pit ${i + 1} < Pit ${i + 2})';
      }
    }

    for (int i = 0; i < cleanLaps.length - 1; i++) {
      if (cleanLaps[i + 1] - cleanLaps[i] < 5) {
        return 'Pit stops must be at least 5 laps apart';
      }
    }


    if (cleanLaps.first < 3) {
      return 'First pit stop must be at least on lap 3';
    }

    if (cleanLaps.last > totalLaps - 5) {
      return 'Last pit stop must be at least 5 laps before the end';
    }

    if (selectedStart != null && cleanTyres.first == selectedStart!['tire_compound']) {
      return 'First pit tyre cannot be the same as start tyre';
    }


    for (int i = 0; i < cleanTyres.length - 1; i++) {
      if (cleanTyres[i] == cleanTyres[i + 1]) {
        return 'Consecutive pit stops cannot use the same tyre compound';
      }
    }

    return null;
  }

  bool canGoNext() {
    switch (currenStep) {
      case 0:
        return selectedGP != null;
      case 1:
        return selectedDriver != null;
      case 2:
        return selectedStart != null;
      case 3:
        if (pitStops == 0) return true;

        final error = validatePitStops();
        if (error != null) {
          setState(() => pitValidationError = error);
          return false;
        }

        setState(() => pitValidationError = null);
        return true;
      default:
        return false;
    }
  }


  void _updatePitStops(int newPitStops) {
    setState(() {
      pitStops = newPitStops;
      pitLaps = List<int?>.filled(newPitStops, null);
      pitTireNames = List<String?>.filled(newPitStops, null);
      pitValidationError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 51, 8, 8).withOpacity(0.15),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Image.asset(
              'assets/images/Logo_tr_cerna.png',
              height: 50,
              width: 45,
            ),
          ),
        ),
      ),
      body: switch (currenStep) {
        0 => _buildGPSelection(),
        1 => _buildDriversSelection(),
        2 => _buildStartSelection(),
        3 => _buildStintSelection(),
        _ => const Placeholder(),
      },
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStintSelection() {
    final maxLaps = selectedGP?['laps'] as int? ?? 57;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PIT STOP STRATEGY',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Number of pit stops',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (int i = 0; i <= 2; i++) ...[
                GestureDetector(
                  onTap: () => _updatePitStops(i),
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: pitStops == i
                          ? const Color.fromARGB(255, 179, 55, 51)
                          : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: pitStops == i
                            ? const Color.fromARGB(255, 179, 55, 51)
                            : Colors.white24,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$i',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

     
          if (pitValidationError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pitValidationError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (pitStops > 0) ...[
            for (int i = 0; i < pitStops; i++) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pit Stop ${i + 1}',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Lap: ${pitLaps[i] ?? '?'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: (pitLaps[i] ?? 10).toDouble(),
                      min: 3,
                      max: (maxLaps - 5).toDouble(),
                      divisions: ((maxLaps - 5) - 3).clamp(1, 1000),
                      activeColor: const Color.fromARGB(255, 179, 55, 51),
                      inactiveColor: Colors.grey.shade800,
                      onChanged: (val) {
                        setState(() {
                          pitLaps[i] = val.toInt();
                          pitValidationError = null;
                        });
                      },
                    ),
                    Text(
                      'Range: 3 - ${maxLaps - 5}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Tyre after pit stop',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tireList.map((tyre) {
                        final name = tyre['tire_compound']?.toString() ?? '';
                        final isSelected = pitTireNames[i] == name;

                        final isSameAsStart = selectedStart != null &&
                            selectedStart!['tire_compound'] == name;

                        final isSameAsPrevious = i > 0 && pitTireNames[i - 1] == name;

                        return GestureDetector(
                          onTap: isSameAsStart || isSameAsPrevious
                              ? null
                              : () {
                                  setState(() {
                                    pitTireNames[i] = name;
                                    pitValidationError = null;
                                  });
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 179, 55, 51)
                                  : (isSameAsStart || isSameAsPrevious
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade900),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color.fromARGB(255, 179, 55, 51)
                                    : (isSameAsStart || isSameAsPrevious
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.white24),
                              ),
                            ),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: isSameAsStart || isSameAsPrevious
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStartSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'SELECT START TIRES',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),
        ),
        Expanded(
          child: tireList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: tireList.length,
                  itemBuilder: (context, index) {
                    final tyre = tireList[index];
                    final name = tyre['tire_compound']?.toString() ?? '';
                    final degradation = tyre['degradation']?.toString() ?? '';
                    final isSelected = selectedStart != null &&
                        selectedStart!['tire_compound'] == tyre['tire_compound'];

                    return GestureDetector(
                      onTap: () => setState(() => selectedStart = tyre),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 179, 55, 51)
                                : Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color.fromARGB(255, 179, 55, 51)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Image.network(
                                gpTyres[name] ?? '',
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey.shade800,
                                    child: const Icon(Icons.error, color: Colors.white),
                                  );
                                },
                              ),
                              const SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Degradation: ${degradation}s/lap',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: isSelected ? Colors.white : Colors.white38,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDriversSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'SELECT DRIVER',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),
        ),
        Expanded(
          child: driverList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: driverList.length,
                  itemBuilder: (context, index) {
                    final driver = driverList[index];
                    final isSelected = selectedDriver != null &&
                        selectedDriver!['driver_first_name'] == driver['driver_first_name'];

                    return GestureDetector(
                      onTap: () => setState(() => selectedDriver = driver),
                      child: Animate(
                        delay: Duration(milliseconds: 80 * index),
                        effects: [
                          FadeEffect(duration: 300.ms),
                          SlideEffect(
                            begin: const Offset(0, 0.2),
                            curve: Curves.easeOut,
                            duration: 400.ms,
                          ),
                          ScaleEffect(
                            begin: const Offset(0.85, 0.85),
                            curve: Curves.easeOutBack,
                            duration: 450.ms,
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Image.network(
                                  gpDrivers[driver['driver_first_name']] ?? '',
                                  width: double.infinity,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 110,
                                      color: Colors.grey.shade800,
                                    );
                                  },
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 110,
                                  color: Colors.black.withOpacity(isSelected ? 0.3 : 0.55),
                                ),
                                if (isSelected)
                                  Container(
                                    width: double.infinity,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 179, 55, 51),
                                        width: 2.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                Positioned(
                                  left: 12,
                                  bottom: 12,
                                  child: Text(
                                    '${driver['driver_first_name']} ${driver['driver_last_name']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGPSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'SELECT CIRCUIT',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),
        ),
        Expanded(
          child: grandPrixList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: grandPrixList.length,
                  itemBuilder: (context, index) {
                    final gp = grandPrixList[index];
                    final isSelected = selectedGP != null &&
                        selectedGP!['grandprix_name'] == gp['grandprix_name'];

                    return GestureDetector(
                      onTap: () => setState(() => selectedGP = gp),
                      child: Animate(
                        delay: Duration(milliseconds: 80 * index),
                        effects: [
                          FadeEffect(duration: 300.ms),
                          SlideEffect(
                            begin: const Offset(0, 0.2),
                            curve: Curves.easeOut,
                            duration: 400.ms,
                          ),
                          ScaleEffect(
                            begin: const Offset(0.85, 0.85),
                            curve: Curves.easeOutBack,
                            duration: 450.ms,
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Image.network(
                                  gpImages[gp['grandprix_name']] ?? '',
                                  width: double.infinity,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 110,
                                      color: Colors.grey.shade800,
                                    );
                                  },
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 110,
                                  color: Colors.black.withOpacity(isSelected ? 0.3 : 0.55),
                                ),
                                if (isSelected)
                                  Container(
                                    width: double.infinity,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 179, 55, 51),
                                        width: 2.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                Positioned(
                                  left: 12,
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      gp['grandprix_name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 179, 55, 51),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${gp['laps']} laps',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'HOME',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (currenStep > 0) {
                        setState(() => currenStep--);
                      }
                    },
                    child: const Text(
                      'PREVIOUS',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: canGoNext()
                    ? const Color.fromARGB(255, 179, 55, 51)
                    : Colors.grey.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: canGoNext()
                    ? () {
                        if (currenStep < 3) {
                          setState(() => currenStep++);
                        } else if (currenStep == 3) {
                          try {
                            final strategy = RaceStrategy(
                              gp: selectedGP!,
                              driver: selectedDriver!,
                              gpId: selectedGP!['id'],
                              driverId: selectedDriver!['id'],
                              startTyre: selectedStart!['tire_compound'],
                              pitStops: pitStops,
                              pitLaps: pitLaps.whereType<int>().toList(),
                              pitTyres: pitTireNames.whereType<String>().toList(),
                              tires: tireList,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FinalResult(strategy: strategy),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null,
                child: Text(
                  currenStep == 3 ? 'SIMULATE' : 'NEXT',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}