class RaceStrategy {
  final Map<String, dynamic> gp;
  final Map<String, dynamic> driver;

  final int driverId;  
  final int gpId;       

  final String startTyre;
  final int pitStops;
  final List<int> pitLaps;
  final List<String> pitTyres;
  final List<Map<String, dynamic>> tires;

  RaceStrategy({
    required this.gp,
    required this.driver,
    required this.driverId,   
    required this.gpId,       
    required this.startTyre,
    required this.pitStops,
    required this.pitLaps,
    required this.pitTyres,
    required this.tires,
  });
}