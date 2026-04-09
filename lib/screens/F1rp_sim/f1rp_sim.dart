import 'package:f1raceplatform/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class F1rpSim extends StatefulWidget {
  const F1rpSim({super.key});

  @override
  State<F1rpSim> createState() => _F1rpSimState();
}

class _F1rpSimState extends State<F1rpSim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: 
       

       Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/lewis.png'),
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
                size: 25,
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
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 39, 39),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
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
                  'Make race-winning decisions',
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
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 7, 7),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Simulation',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
)
      
        
       
        
        


    );
  }
}