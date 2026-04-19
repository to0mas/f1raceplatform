import 'dart:ui';

import 'package:f1raceplatform/services/database_service.dart';
import 'package:flutter/material.dart';

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

  final Map<String, String> gpImages = {
    'Bahrain Grand Prix': 'https://media.formula1.com/image/upload/c_lfill,w_2048/q_auto/v1740000001/content/dam/fom-website/manual/2023/BahrainGP/GettyImages-1471457958.webp',
    'Australian Grand Prix': 'https://images.ctfassets.net/gy95mqeyjg28/2EkenT3S9x0YTd6UpW0vxT/4badbff144512a6efbf1838561187361/2265031100.jpg?w=3840&q=75&fm=webp&fit=fill',
    'Japanese Grand Prix': 'https://media.formula1.com/image/upload/f_auto/q_auto/v1677245019/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Japan.jpg',
    'British Grand Prix': 'https://media.formula1.com/image/upload/c_lfill,w_3392/q_auto/v1740000001/content/dam/fom-website/sutton/2021/GreatBritain/Sunday/1329376119.webp',
    'Italian Grand Prix': 'https://media.formula1.com/image/upload/f_auto/q_auto/v1677238736/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Italy.jpg',
  };

  Map<String, dynamic>? selectedGP;

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
        1 => const Placeholder(),
        2 => const Placeholder(),
        _ => const Placeholder(),
      },
      bottomNavigationBar: _buildBottomBar(),
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
              final isSelected = selectedGP == gp;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGP = gp;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
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
                          color: Colors.black.withOpacity(
                            isSelected ? 0.3 : 0.55,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: double.infinity,
                            height: 110,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE10600),
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
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (currenStep > 0) {
                        setState(() => currenStep--);
                      }
                    },
                    child: const Text(
                      'PREVIOUS',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 179, 55, 51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  if (currenStep < 2) {
                    setState(() => currenStep++);
                  }
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(
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