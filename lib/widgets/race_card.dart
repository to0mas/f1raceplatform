import 'package:f1raceplatform/models/races.dart';
import 'package:flutter/material.dart';
import 'package:f1raceplatform/api_calls/races_call.dart';


class RaceCard extends StatefulWidget {
  const RaceCard({super.key});

  @override
  State<RaceCard> createState() => _RaceCardState();
}

class _RaceCardState extends State<RaceCard> {

List<Race> races = [];
bool isLoading = true;

  @override
  void initState(){
    super.initState();
    loadRaces();
  }

  void loadRaces() async{
    try{
        final racesInfo = await RacesCall().getRace();
         print('Races loaded: ${racesInfo.length}');
        setState(() {
          races = racesInfo;
          isLoading = false;
        });
    }
    catch(e){
      setState(() {
        print('Error: $e'); 
        isLoading = false;
      });
    }
  }
  Widget build(BuildContext context) {
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
  child: Container(
    height: 180,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: AssetImage('assets/images/race.jpeg.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
       
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'NEXT RACE',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              races[0].raceName.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  races[0].date?.toString().split(' ')[0] ?? 'TBD',
                  style: TextStyle(
                    color: const Color.fromARGB(179, 255, 255, 255),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),


  

);


      
  }
}