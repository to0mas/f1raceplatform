import 'package:f1raceplatform/screens/home.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
import 'package:path/path.dart';
import 'dart:ui';
>>>>>>> trbranch
class F1rpSim extends StatefulWidget {
  const F1rpSim({super.key});

  @override
  State<F1rpSim> createState() => _F1rpSimState();
}

class _F1rpSimState extends State<F1rpSim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sim.png'),
            fit: BoxFit.cover,
=======

        body: 
       

       Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/sim.png'),
      fit: BoxFit.cover,
    ),
  ),
  child: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: CircleAvatar(
              radius: 24,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 26,
              ),
              backgroundColor: const Color.fromARGB(148, 88, 89, 90),
            ),
          ),
        ],
      ),
    ),
    Spacer(),
    Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 39, 39),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'BECOME A RACING ENGINEER',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(158, 236, 236, 236),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'MAKE A RACE WINNIG DECISION',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 212, 86, 86).withOpacity(0.2), // glass efekt
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 206, 6, 6).withOpacity(0.1),
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            style: TextButton.styleFrom(
            
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                
                SizedBox(width: 15),
                Text(
                  'START NOW',
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
              ),
            ],
>>>>>>> trbranch
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFE10600).withOpacity(0.6),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFFE10600).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE10600).withOpacity(0.15),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BECOME A RACING ENGINEER',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFFD700),
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'MAKE THE BEST\nTEAM DECISION',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE10600),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                            shadowColor: Color(0xFFE10600).withOpacity(0.5),
                          ),
                          child: Text(
                            'START SIMULATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}