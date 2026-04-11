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
import 'package:f1raceplatform/theme/theme_data.dart';
import 'package:gradient_generator/gradient_generator.dart';
import 'package:f1raceplatform/models/races.dart';

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


body: SingleChildScrollView(
  child: Column(
    children: [

    

   

      

GradientContainer(
  gradient: GradientX.linear(
    colors: [const Color.fromARGB(150, 197, 11, 11), Color(Color.fromARGB(255, 0, 0, 0).value)],
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
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Standings()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0x94BD3030),
        elevation: 5,
        shadowColor: const Color.fromARGB(255, 189, 48, 48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Full Standings',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    ),
  ),
),

SizedBox(height: 20),

InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => F1rpSim()),
    );
  },
  borderRadius: BorderRadius.circular(10),
  child: Padding(  
    padding: const EdgeInsets.all(15.0),
    child: Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
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





SizedBox(height: 40),
  RaceCard(),





    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
       
       children: [
        Container(
          
            
             height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: NetworkImage(news[0].urlImg),
                   
                fit: BoxFit.cover,
              ),
              
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.black.withOpacity(0.5), 
                ),
                
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                         
                          Text(
                            'BREAKING NEWS',
                            
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 0, 0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            news[0].title.toUpperCase(),
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              
              
              ),
              

             
        ),
        Container(
            height: 150,

           decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: const Color.fromARGB(255, 61, 61, 61), 
              ),

            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news[0].description,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 168, 168, 168),
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                ElevatedButton(
                  
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(150, 189, 48, 48),
          
        ),
        child: Padding(
         
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('Read full story', style: TextStyle(color: Colors.white))),
        ),
        onPressed: () {
           setState(() {
          'Read full article at: ${news[0].source}';
            });
          },
      ),
                ],
              ),
            ),
        ),
       ],
        
      ),
    ),
  ],
  ),
),



   


     backgroundColor: appTheme.scaffoldBackgroundColor,
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