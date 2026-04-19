import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/api_calls/driver_standings_call.dart';
import 'package:f1raceplatform/api_calls/news_call.dart';

import 'package:f1raceplatform/models/driver.dart';
import 'package:f1raceplatform/models/driver_standing.dart';
import 'package:f1raceplatform/models/news.dart';


import 'package:f1raceplatform/screens/standings.dart';
import 'package:f1raceplatform/screens/F1rp_sim/f1rp_sim.dart';
import 'package:f1raceplatform/widgets/race_card.dart';
import 'package:f1raceplatform/theme/theme_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Driver> drivers = [];
  List<DriverStanding> driverStandings = [];
  List<News> news = [];

  @override
  void initState() {
    super.initState();

    Future.wait([
      DriverCall().getDrivers(),
      DriverStandingsCall().getDriverStandings(),
      NewsCall().getNews(),
    ]).then((results) {
      setState(() {
        drivers = results[0] as List<Driver>;
        driverStandings = results[1] as List<DriverStanding>;
        news = results[2] as List<News>;

        drivers.sort((a, b) {
          final aStanding = driverStandings.firstWhere(
            (s) => s.driverCode == a.nameAcronym,
            orElse: () => DriverStanding(
              driverCode: a.nameAcronym,
              position: 9999,
              points: 0,
              wins: 0,
              givenName: '',
              familyName: '',
            ),
          );

          final bStanding = driverStandings.firstWhere(
            (s) => s.driverCode == b.nameAcronym,
            orElse: () => DriverStanding(
              driverCode: b.nameAcronym,
              position: 9999,
              points: 0,
              wins: 0,
              givenName: '',
              familyName: '',
            ),
          );

          return aStanding.position.compareTo(bStanding.position);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.scaffoldBackgroundColor,

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 197, 11, 11).withOpacity(0.15),
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
        title: Center(
          child: Image.asset(
            'assets/images/Logo_tr_cerna.png',
            height: 50,
            width: 45,
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            // DRIVER STRIP
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(82, 197, 11, 11),
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driver = drivers[index];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(
                            int.parse('FF${driver.teamColour}', radix: 16),
                          ),
                          backgroundImage: driver.headshotUrl != null &&
                                  driver.headshotUrl!.isNotEmpty
                              ? NetworkImage(driver.headshotUrl!)
                              : const AssetImage('assets/images/Logo_tr.png')
                                  as ImageProvider,
                        ),
                      ),
                      Text(
                        driver.nameAcronym,
                        style: TextStyle(
                          color: Color(
                            int.parse('FF${driver.teamColour}', radix: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // FULL STANDINGS BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StandingsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(150, 197, 11, 11)
                                .withOpacity(0.3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Full Standings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SIMULATOR CARD
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/podium-mclarens-boys-defeated.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo_tr.png',
                      height: 100,
                      width: 100,
                    ),
                    const Text(
                      "SIMULATOR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const F1rpSim(),
                          ),
                        );
                      },
                      child: const Text("ENTER SIMULATOR"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            const RaceCard(),
          ],
        ),
      ),

      // BOTTOM BAR
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.date_range), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: ''),
        ],
      ),
    );
  }
}