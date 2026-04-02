import 'package:f1raceplatform/api_calls/driver_call.dart';
import 'package:f1raceplatform/models/driver.dart';
import 'package:flutter/material.dart';
import 'package:f1raceplatform/theme/theme_data.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Driver> drivers = [];
  
  @override
  void initState() {
    DriverCall().getDrivers().then((fetchedDrivers) {
      setState(() {
        drivers = fetchedDrivers;
      });
    });
    super.initState();
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


body: ListView.builder(
  
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
         backgroundColor: Color(int.parse('FF' + driver.teamColour, radix: 16)),
      backgroundImage: driver.headshotUrl != null && driver.headshotUrl!.isNotEmpty
      ? NetworkImage(driver.headshotUrl!)
      : const AssetImage('assets/images/Logo_tr.png') as ImageProvider,
      ),
    ),
    Text(
      driver.nameAcronym,
      style: TextStyle(
        color: Color(int.parse('FF' + driver.teamColour, radix: 16)),
        fontSize: 12,
      ),
    ),
  ],
);
  }
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