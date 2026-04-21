import 'dart:ui';

import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/api_calls/driver_standings_call.dart';
import 'package:f1raceplatform/api_calls/news_call.dart';
import 'package:f1raceplatform/models/driver.dart';
import 'package:f1raceplatform/models/driver_standing.dart';
import 'package:f1raceplatform/models/news.dart';
import 'package:f1raceplatform/screens/F1rp_sim/f1rp_sim.dart';
import 'package:f1raceplatform/screens/news.dart';
import 'package:f1raceplatform/screens/schedule_screen.dart';
import 'package:f1raceplatform/screens/standings.dart';
import 'package:f1raceplatform/widgets/f1_weather_card.dart';
import 'package:f1raceplatform/widgets/race_card.dart';
import 'package:flutter/material.dart';
import 'package:f1raceplatform/theme/theme_data.dart';
import 'package:gradient_generator/gradient_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Driver> drivers = [];
  List<DriverStanding> driverStandings = [];
  List<News> news = [];

  int currentPage = 0;

  final List<Widget> pages = [
    const SizedBox.shrink(),
    const Schedule(),
    const NewsScreen(),
    const StandingsScreen(),
  ];

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,

        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 197, 11, 11).withOpacity(0.15),
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

      body: currentPage == 0 
          ? HomeContent(drivers: drivers) 
          : pages[currentPage],

      backgroundColor: appTheme.scaffoldBackgroundColor,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: BottomNavigationBar(
              currentIndex: currentPage,
              onTap: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.4),
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color.fromARGB(255, 179, 55, 51),
              unselectedItemColor: Colors.white.withOpacity(0.4),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 28),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.date_range, size: 28),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper, size: 28),
                  label: 'News',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class HomeContent extends StatelessWidget {
  final List<Driver> drivers;

  const HomeContent({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          GradientContainer(
            gradient: GradientX.linear(
              colors: [const Color.fromARGB(82, 197, 11, 11), Color(Color.fromARGB(255, 0, 0, 0).value)],
              angle: -360,
            ),
            child: SizedBox(
              height: 120,
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
                          backgroundColor: Color(int.parse('FF${driver.teamColour}', radix: 16)),
                          backgroundImage: driver.headshotUrl != null && driver.headshotUrl!.isNotEmpty
                              ? NetworkImage(driver.headshotUrl!)
                              : const AssetImage('assets/images/Logo_tr.png') as ImageProvider,
                        ),
                      ),
                      Text(
                        driver.nameAcronym,
                        style: TextStyle(
                          color: Color(int.parse('FF${driver.teamColour}', radix: 16)),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StandingsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0x94BD3030).withOpacity(0.3),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.flag_sharp, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Full Standings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Padding(  
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(90, 8, 1, 0),
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: Image.asset('assets/images/podium-mclarens-boys-defeated.jpg').image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Logo_tr.png',
                            height: 100,
                            width: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'SIMULATOR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => F1rpSim()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(150, 197, 11, 11).withOpacity(0.5),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Text(
                              'ENTER SIMULATOR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
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

          SizedBox(height: 40),
          RaceCard(),
         SizedBox(height: 20),
          Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: F1WeatherCard(apiKey: '00488f65a339d7ecf4c890cf8c5d6f5e'),
                    ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}