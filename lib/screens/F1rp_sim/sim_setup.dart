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
  List<int?> pitLaps = [null, null];
  List<String?> pitTireNames = [null, null];

  final Map<String, String> gpTyres = {
    'Soft': 'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/red-parentesi.png',
    'Medium': 'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/yellow-parentesi.png',
    'Hard': 'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/white-parentesi.png',
    'Intermediate': 'https://tyre-assets.pirelli.com/images/global/380/862/cinturato-green-intermediate-4505508953587.png',
    'Full Wet': 'https://tyre-assets.pirelli.com/images/global/968/233/cinturato-blue-wet-4505508953865.png',
  };

  final Map<String, String> gpImages = {
    'Bahrain Grand Prix': 'https://media.formula1.com/image/upload/c_lfill,w_2048/q_auto/v1740000001/content/dam/fom-website/manual/2023/BahrainGP/GettyImages-1471457958.webp',
    'Australian Grand Prix': 'https://images.ctfassets.net/gy95mqeyjg28/2EkenT3S9x0YTd6UpW0vxT/4badbff144512a6efbf1838561187361/2265031100.jpg?w=3840&q=75&fm=webp&fit=fill',
    'Japanese Grand Prix': 'https://media.formula1.com/image/upload/f_auto/q_auto/v1677245019/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Japan.jpg',
    'British Grand Prix': 'https://media.formula1.com/image/upload/c_lfill,w_3392/q_auto/v1740000001/content/dam/fom-website/sutton/2021/GreatBritain/Sunday/1329376119.webp',
    'Italian Grand Prix': 'https://media.formula1.com/image/upload/f_auto/q_auto/v1677238736/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Italy.jpg',
  };

  final Map<String, String> gpDrivers = {
    'Max': 'https://gpticketstore.vshcdn.net/uploads/images/12172/teams-lineups-f1-max-verstapen.jpg',
    'Lando': 'https://media.formula1.com/image/upload/t_16by9Centre/c_lfill,w_3392/q_auto/v1740000001/trackside-images/2024/F1_Grand_Prix_Of_Singapore/2173723984.webp',
    'Charles': 'https://cd8.incdatagate.cz/images/1f12bb3a-944b-6418-b479-41c093038f50/720x405.jpg',
    'George': 'https://cd8.incdatagate.cz/images/1f0717cf-1997-659c-89dd-c300895e78dd/720x405.jpg',
    'Fernando': 'https://f1chronicle.com/wp-content/uploads/2023/11/GP2320_141541_ONZ8936-scaled.jpg',
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
    final db = await DatabaseService.instance.getDatabase();
    final gp = await db.query('grandprix');
    final drivers = await db.query('drivers');
    final tires = await db.query('tires');

    setState(() {
      grandPrixList = gp;
      driverList = drivers;
      tireList = tires;
    });
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
        if (pitStops == 1) return pitLaps[0] != null && pitTireNames[0] != null;
        if (pitStops == 2) return pitLaps[0] != null && pitTireNames[0] != null && pitLaps[1] != null && pitTireNames[1] != null;
        return false;
      default:
        return false;
    }
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

          // Výběr počtu pit stopů
          const Text(
            'Number of pit stops',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (int i = 0; i <= 2; i++) ...[
                GestureDetector(
                  onTap: () => setState(() {
                    pitStops = i;
                    pitLaps = [null, null];
                    pitTireNames = [null, null];
                  }),
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

         
          for (int i = 0; i < pitStops; i++) ...[
            Text(
              'Pit stop ${i + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Výběr kola
            Text(
              'Lap: ${pitLaps[i] ?? '-'}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Slider(
              value: (pitLaps[i] ?? 1).toDouble(),
              min: 1,
              max: (selectedGP?['laps'] ?? 57).toDouble(),
              divisions: (selectedGP?['laps'] ?? 57) - 1,
              activeColor: const Color.fromARGB(255, 179, 55, 51),
              inactiveColor: Colors.grey.shade800,
              onChanged: (val) {
                setState(() {
                  pitLaps[i] = val.toInt();
                });
              },
            ),

            const SizedBox(height: 8),

          
            const Text(
              'Tyre after pit stop',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Wrap(
                spacing: 5,
                children: tireList.map((tyre) {
                  final name = tyre['tire_compound']?.toString() ?? '';
                  final isSelected = pitTireNames[i] == name;
                  return GestureDetector(
                    onTap: () => setState(() => pitTireNames[i] = name),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 179, 55, 51)
                            : Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color.fromARGB(255, 179, 55, 51)
                              : Colors.white24,
                        ),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
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
          child: ListView.builder(
            itemCount: tireList.length,
            itemBuilder: (context, index) {
              final tyre = tireList[index];
              final name = tyre['tire_compound']?.toString() ?? '';
              final degradation = tyre['degradation']?.toString() ?? '';
              final isSelected =
                  selectedStart != null &&
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
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Image.network(
                          gpTyres[name] ?? '',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            '${degradation}s',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
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
          child: ListView.builder(
            itemCount: driverList.length,
            itemBuilder: (context, index) {
              final driver = driverList[index];
              final isSelected =
                  selectedDriver != null &&
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
          child: ListView.builder(
            itemCount: grandPrixList.length,
            itemBuilder: (context, index) {
              final gp = grandPrixList[index];
              final isSelected =
                  selectedGP != null &&
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              color: const Color.fromARGB(255, 179, 55, 51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                if (currenStep < 3 && canGoNext()) {
                  setState(() => currenStep++);
                } else if (currenStep == 3 && canGoNext()) {

                  final strategy = RaceStrategy(
  gp: selectedGP!,
  driver: selectedDriver!,
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
                }
              },

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