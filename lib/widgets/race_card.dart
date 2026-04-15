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
  void initState() {
    super.initState();
    loadRaces();
  }

  void loadRaces() async {
    try {
      final racesInfo = await RacesCall().getRace();

      setState(() {
        races = racesInfo;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   

    return Column(
      children: [
     
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/race.jpeg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'NEXT RACE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    races[0].raceName.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        races[0].date?.toString().split(' ')[0] ?? 'TBD',
                        style: const TextStyle(
                          color: Color.fromARGB(179, 255, 255, 255),
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

     
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
<<<<<<< HEAD
                Icon(Icons.calendar_today, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  races[0].date?.toString().split(' ')[0] ?? 'TBD',
                  style: TextStyle(
                  color: Color(0xFFFFD700),
                    fontSize: 14,
=======
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 255, 0, 0).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.4),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              races[0].laps.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'LAPS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            races[0].corners.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'CORNERS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],

                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
>>>>>>> trbranch
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}