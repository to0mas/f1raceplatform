import 'package:f1raceplatform/models/race_strategy.dart';
import 'package:f1raceplatform/services/strategy_calculator.dart';
import 'package:flutter/material.dart';

class FinalResult extends StatefulWidget {


const FinalResult({
  super.key,
  required this.strategy,
});

  final RaceStrategy strategy;

  @override
  State<FinalResult> createState() => _FinalResultState();
}

class _FinalResultState extends State<FinalResult> {
 
 late double totalTime;
 late List<Map<String, dynamic>> breakdown;

 @override
  void initState(){
    super.initState();
    _calculateResult();
  }

void _calculateResult() {
  final s = widget.strategy;

  final result = RaceDataPrep.calculateRaceTime(
    gp: s.gp,
    tires: s.tires,
    startCompound: s.startTyre,
    pitTyres: s.pitTyres,
    pitLaps: s.pitLaps,
  );

  setState(() {
    totalTime = result;
  });
}


    final Map<String, String> gpTyres = {
    'Soft': 'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/red-parentesi.png',
    'Medium': 'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/yellow-parentesi.png',
    'Hard': 'https://tyre-assets.pirelli.com/staticfolder/Tyre/resources/img/white-parentesi.png',
    'Intermediate': 'https://tyre-assets.pirelli.com/images/global/380/862/cinturato-green-intermediate-4505508953587.png',
    'Full Wet': 'https://tyre-assets.pirelli.com/images/global/968/233/cinturato-blue-wet-4505508953865.png',
  };

  final Map<String, String> gpImages = {
    'Bahrain Grand Prix': 'https://media.formula1.com/image/upload/c_lfill,w_2048/q_auto/v1740000001/content/dam/fom-website/manual/2023/BahrainGP/GettyImages-1471457958.webp',
    'Australian Grand Prix': 'https://images.ctfassets.net/gy95mqeyjg28/2EkenT3S9x0YTd6UpW0vxT/4badbff144512a6efbf1838561187361/2265031100.jpg?w=3840&q=75&fm=webp&fit=fill',
    'Japanese Grand Prix': 'https://media.formula1.com/image/upload/f_auto/q_auto/v1677245019/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Japan.jpg',
    'British Grand Prix': 'https://media.formula1.com/image/upload/c_lfill,w_3392/q_auto/v1740000001/content/dam/fom-website/sutton/2021/GreatBritain/Sunday/1329376119.webp',
    'Italian Grand Prix': 'https://media.formula1.com/image/upload/f_auto/q_auto/v1677238736/content/dam/fom-website/2018-redesign-assets/Racehub%20header%20images%2016x9/Italy.jpg',
  };

  final Map<String, String> gpDrivers = {
    'Max': 'https://gpticketstore.vshcdn.net/uploads/images/12172/teams-lineups-f1-max-verstapen.jpg',
    'Lando': 'https://media.formula1.com/image/upload/t_16by9Centre/c_lfill,w_3392/q_auto/v1740000001/trackside-images/2024/F1_Grand_Prix_Of_Singapore/2173723984.webp',
    'Charles': 'https://cd8.incdatagate.cz/images/1f12bb3a-944b-6418-b479-41c093038f50/720x405.jpg',
    'George': 'https://cd8.incdatagate.cz/images/1f0717cf-1997-659c-89dd-c300895e78dd/720x405.jpg',
    'Fernando': 'https://f1chronicle.com/wp-content/uploads/2023/11/GP2320_141541_ONZ8936-scaled.jpg',
  };

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: Column(
  children: [
 Column(
  children: [
   ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: SizedBox(
    height: 150,
    width: double.infinity,
    child: Stack(
      children: [
        Image.network(
          gpImages[widget.strategy.gp['grandprix_name']] ?? '',
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),

        Container(
          width: double.infinity,
          height: 150,
          color: Colors.black.withOpacity(0.5),
        ),
      ],
    ),
  ),
),

    const SizedBox(height: 12),

    ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: SizedBox(
    height: 150,
    width: double.infinity,
    child: Stack(
      children: [
        Image.network(
          gpDrivers[widget.strategy.driver['driver_first_name']] ?? '',
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
          
        ),

        Container(
          width: double.infinity,
          height: 150,
          color: Colors.black.withOpacity(0.5),
        ),

        
      ],

      
    ),
    
  ),
),
const SizedBox(height: 50),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    
    Column(
      children: [
        const Text("START", style: TextStyle(color: Colors.white70)),
        Image.network(
        gpTyres[widget.strategy.startTyre] ?? '',
          height: 100,
        ),
      ],
    ),

    const SizedBox(width: 10),

   
    ...List.generate(widget.strategy.pitStops, (i) {
      return Row(
        children: [
          const Text("→", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 5),

          Column(
            children: [
              Text(
                "L${widget.strategy.pitLaps[i]}",
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight:FontWeight.bold),
              ),
              Image.network(
                gpTyres[widget.strategy.pitTyres[i]] ?? '',
                height: 100,
              ),
            ],
          ),

          const SizedBox(width: 10),
        ],
      );
    }),
  ],
)

  ],
)
  ],
  
),





      ),
    );
  }
  }
  