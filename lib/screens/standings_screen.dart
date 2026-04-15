import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/api_calls/driver_standings_call.dart';
import 'package:f1raceplatform/models/driver.dart';
import 'package:f1raceplatform/models/driver_standing.dart';
import 'package:flutter/material.dart';

class Standings extends StatefulWidget {
  const Standings({super.key});

  @override
  State<Standings> createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
 

List<DriverStanding> driverStandings = [];
List<Driver> drivers = [];
bool isLoading = true;

@override
void initState(){
  super.initState();
  loadData();

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
}

void loadData() async {
  try {
    final driversResult = await DriverCall().getDrivers();
    final standingsResult = await DriverStandingsCall().getDriverStandings();

    setState(() {
      drivers = driversResult;
      driverStandings = standingsResult;
      isLoading = false;
    });
  } catch (e) {
    print('Error: $e');
    setState(() {
      isLoading = false;
    });
  }
}


  Widget build(BuildContext context) {
    return Scaffold(
      
       appBar: AppBar(
      

    backgroundColor: const Color.fromARGB(150, 197, 11, 11),

    title: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
       
        Center(
          child: Image.asset(
            'assets/images/Logo_tr_cerna.png',
            height: 50,
            width: 45,
          ),
        ),
      
      
      
       
      ],
      
      ),
    ),   
     ),






    bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(Color(0xFF1A1A1A).value),
        showSelectedLabels: false,
  showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
          
            ),
            label: '', 
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
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
