import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/api_calls/driver_standings_call.dart';
import 'package:f1raceplatform/api_calls/news_call.dart';
import 'package:f1raceplatform/models/driver.dart';
import 'package:f1raceplatform/models/driver_standing.dart';
import 'package:f1raceplatform/models/news.dart';
import 'package:f1raceplatform/screens/F1rp_sim/f1rp_sim.dart';
import 'package:f1raceplatform/screens/standings.dart';
import 'package:f1raceplatform/widgets/race_card.dart';
import 'package:flutter/material.dart';
import 'package:f1raceplatform/api_calls/races_call.dart';
import 'package:f1raceplatform/models/races.dart';

import 'package:gradient_generator/gradient_generator.dart';

import 'dart:ui';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<Driver> drivers = [];
List<DriverStanding> driverStandings = [];
List<News> news = [];

  get races => null;


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

      drivers.sort((a,b){
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
        orElse: () => DriverStanding( driverCode: a.nameAcronym,
            position: 9999,
            points: 0,
            wins: 0,
            givenName: '',
            familyName: '',),

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
  automaticallyImplyLeading: false,
  backgroundColor: Colors.transparent,
  elevation: 0,

  flexibleSpace: Padding(
    padding: const EdgeInsets.all(1.0),
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(111, 167, 51, 51).withOpacity(0.2), // glass efekt
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    ),
  ),

  title: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Center(
      child: Image.asset(
        'assets/images/Logo_tr_cerna.png',
        height: 50,
        width: 45,
      ),
    ),
  ),
),

body: SingleChildScrollView(
  child: Column(
    children: [

    

   

      

GradientContainer(
  gradient: GradientX.linear(
    colors: [const Color.fromARGB(15, 197, 11, 11), Color(Color.fromARGB(255, 0, 0, 0).value)],
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
              padding: const EdgeInsets.all(12.0),
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
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 212, 86, 86).withOpacity(0.1), // glass efekt
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 212, 86, 86).withOpacity(0.1),
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Standings()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 15),
                Text(
                  'Full Standings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
),

SizedBox(height: 15),

InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => F1rpSim()),
    );
  },
  borderRadius: BorderRadius.circular(16),
  child: Padding(  
    padding: const EdgeInsets.all(15.0),
    child: Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
              


            
               border: Border.all(
              color: const Color.fromARGB(178, 212, 86, 86),
            ),
            image: DecorationImage(
              image: Image.asset('assets/images/podium-mclarens-boys-defeated.jpg').image,
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo_tr.png',
                height: 80,
                width: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'SIMULATOR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
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





SizedBox(height:20),
  RaceCard(),


    
  ],
  ),
),



   


   
      bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.shifting,
  backgroundColor: const Color.fromARGB(255, 218, 10, 10),
  showSelectedLabels: false,
  showUnselectedLabels: false,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '',
      backgroundColor: Color.fromARGB(242, 189, 48, 48),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.date_range),
      label: '',
      
    ),
   
    BottomNavigationBarItem(
      icon: Icon(Icons.brightness_1_rounded),
      label: '',
    
      
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.brightness_1_rounded),
      label: '',
  
    ),
  ],
),
    );
  }
}