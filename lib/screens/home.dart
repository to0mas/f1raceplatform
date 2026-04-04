import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/api_calls/driver_standings_call.dart';
import 'package:f1raceplatform/api_calls/news_call.dart';
import 'package:f1raceplatform/models/driver.dart';
import 'package:f1raceplatform/models/driver_standing.dart';
import 'package:f1raceplatform/models/news.dart';
import 'package:flutter/material.dart';
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

      drivers.sort((a,b){
       final aStanding = driverStandings.firstWhere(
        (s) => s.driverCode == a.nameAcronym,
        orElse: () => DriverStanding(driverCode: a.nameAcronym, position: 9999),
       );

       final bStanding = driverStandings.firstWhere(

        (s) => s.driverCode == b.nameAcronym,
        orElse: () => DriverStanding(driverCode: b.nameAcronym, position: 9999),

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

    backgroundColor: Color(Color(0xFF1A1A1A).value),
		foregroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

     
      Center(
        child: Image.asset(
          'assets/images/Logo_tr.png',
          height: 45,
          width: 45,
        ),
      ),
    

     
    ],)
 
      
     
     ),


body: Column(
  children: [

    

    Padding(
      padding: const EdgeInsets.all(10.0),
    
        child: Text(
          
          '2026 Driver Standings',
           textAlign: TextAlign.left,
          style: TextStyle(
            color: const Color.fromARGB(255, 59, 58, 58),
            fontSize: 18,
            fontWeight: FontWeight.normal,
            
          ),
        ),
    
    ),

    SizedBox(
      height: 100,
      child: ListView.builder(
        
        
        scrollDirection: Axis.horizontal,
        
        itemCount: drivers.length,
        itemBuilder: (context, index){
          final driver = drivers[index];
          
      
      
      
          return Column(
      
            
      
        children:
        
         [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              fontSize: 12,
            ),
          ),
        ],
      );
        }
        ),
    ),



    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(

                  
            
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  height: 200,
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                   image: NetworkImage(news[1].urlImg),
                   colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
),

            child: Column(
              children: [
                Text(
                  news[1].title.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  news[1].description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            )

          
                  
                  
          ),
        ],
      ),
    ),
  ],
),

   


     backgroundColor: appTheme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(Color(0xFF1A1A1A).value),
        showSelectedLabels: false,
  showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
            color: Color(0xFFE10600),
            ),
            label: '', 
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ice_skating),
            label: '', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ice_skating),
            label: '', 
          ),
        ],
      ),
    );
  }
}