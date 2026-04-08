import 'package:flutter/material.dart';

class F1rpSim extends StatefulWidget {
  const F1rpSim({super.key});

  @override
  State<F1rpSim> createState() => _F1rpSimState();
}

class _F1rpSimState extends State<F1rpSim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          height: double.infinity,
          width: double.infinity,
          
          decoration: BoxDecoration(
            image: DecorationImage(
                  image: Image.asset('assets/images/97533764d1830db44b076daf1cad0419.jpg').image,
              fit: BoxFit.cover,
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber
                    ),

                    height: 220,
                    width: double.infinity,
                    
                  ),
                )
            ],
          ),
          
        )
    );
  }
}