import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._privateConstructor();
  static Database? _database;


// Grand Prix table constants
  final String _grandprixTable = 'grandprix'; // table name
  final String _grandPrixId = 'id'; // id column
  final String _grandPrixName = 'grandprix_name'; // name column
  final String _grandPrixLaps = 'laps'; // laps column


// Driver table constants
  final String _driverTable = 'drivers'; // table name
  final String _driverId = 'id'; // id column
  final String _driverFirstName = 'driver_first_name'; // first name column
  final String _driverLastName = 'driver_last_name'; // last name column


  // Tires table constants
  final String _tiresTable = 'tires'; // table name
  final String _tireId = 'id'; // id column
  final String _tireCompound = 'tire_compound'; // tire compound column
  final String _degradation = 'degradation'; // tire degradation column


  // Drivers perdormance table constants
  final String _driversPerformanceTable = 'drivers_performance'; // table name
  final String _performanceId = 'id'; // id column
  final String _driverIdForeignKey = 'driver_id'; // foreign key to drivers table
  final String _grandPrixIdForeignKey = 'grandprix_id'; // foreign key to grand prix table
  final String _lapTime = 'lap_time'; // lap time column
  final String _DNF = 'dnf'; // did not finish column (boolean)



  DatabaseService._privateConstructor();

  Future<Database> getDatabase() async {

    if (_database != null) return _database!;

    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'f1_race_platform.db');

    _database = await openDatabase(
      databasePath,
      version: 1, 
     onCreate: (db, version) async {
  await db.execute('''
    CREATE TABLE $_grandprixTable(
      $_grandPrixId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_grandPrixName TEXT,
      $_grandPrixLaps INTEGER
    )
  ''');

  
  
  await db.execute('''
    CREATE TABLE $_driverTable(
      $_driverId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_driverFirstName TEXT,
      $_driverLastName TEXT
    )
  ''');
  
  await db.execute('''
    CREATE TABLE $_tiresTable(
      $_tireId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_tireCompound TEXT,
      $_degradation REAL
    )
  ''');
  
  await db.execute('''
    CREATE TABLE $_driversPerformanceTable(
      $_performanceId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_driverIdForeignKey INTEGER,
      $_grandPrixIdForeignKey INTEGER,
      $_lapTime REAL,
      FOREIGN KEY ($_driverIdForeignKey) REFERENCES $_driverTable($_driverId),
      FOREIGN KEY ($_grandPrixIdForeignKey) REFERENCES $_grandprixTable($_grandPrixId)
    )
  ''');

//gp
  await db.insert(_grandprixTable, { 
    _grandPrixName: 'Bahrain Grand Prix',
    _grandPrixLaps: 57,
  });
    await db.insert(_grandprixTable, {
    _grandPrixName: 'Australian Grand Prix',
    _grandPrixLaps: 58,
  });

     await db.insert(_grandprixTable, {
    _grandPrixName: 'Japanese Grand Prix',
    _grandPrixLaps: 57,
  });
      await db.insert(_grandprixTable, {
    _grandPrixName: 'British Grand Prix',
    _grandPrixLaps: 52,
  });
       await db.insert(_grandprixTable, {
    _grandPrixName: 'Italian Grand Prix',
    _grandPrixLaps: 53,
  });

//driver
  await db.insert(_driverTable, {
  _driverFirstName: 'Max',
  _driverLastName: 'Verstappen',
});
await db.insert(_driverTable, {
  _driverFirstName: 'Lando',
  _driverLastName: 'Norris',
});
await db.insert(_driverTable, {
  _driverFirstName: 'Charles',
  _driverLastName: 'Leclerc',
});
await db.insert(_driverTable, {
  _driverFirstName: 'George',
  _driverLastName: 'Russell',
});
await db.insert(_driverTable, {
  _driverFirstName: 'Fernando',
  _driverLastName: 'Alonso',
});

//pneu
await db.insert(_tiresTable, {
  _tireCompound: 'Soft',
  _degradation: 0.15,
});
await db.insert(_tiresTable, {
  _tireCompound: 'Medium',
  _degradation: 0.10,
});
await db.insert(_tiresTable, {
  _tireCompound: 'Hard',
  _degradation: 0.05,
});
await db.insert(_tiresTable, {
  _tireCompound: 'Intermediate',
  _degradation: 0.20,
});
await db.insert(_tiresTable, {
  _tireCompound: 'Full Wet',
  _degradation: 0.30,
});


//final 
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 1, 
  _grandPrixIdForeignKey: 1, 
  _lapTime: 95.900,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 2, 
  _grandPrixIdForeignKey: 1, 
  _lapTime: 96.050,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 3, 
  _grandPrixIdForeignKey: 1, 
  _lapTime: 96.200,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 4, 
  _grandPrixIdForeignKey: 1, 
  _lapTime: 96.350,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 5, 
  _grandPrixIdForeignKey: 1, 
  _lapTime: 96.650,
});


await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 1, 
  _grandPrixIdForeignKey: 2, 
  _lapTime: 85.100,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 2, 
  _grandPrixIdForeignKey: 2, 
  _lapTime: 85.250,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 3, 
  _grandPrixIdForeignKey: 2, 
  _lapTime: 85.400,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 4, 
  _grandPrixIdForeignKey: 2, 
  _lapTime: 85.550,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 5, 
  _grandPrixIdForeignKey: 2, 
  _lapTime: 85.850,
});



await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 1, 
  _grandPrixIdForeignKey: 3, 
  _lapTime: 95.750,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 2, 
  _grandPrixIdForeignKey: 3, 
  _lapTime: 95.900,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 3, 
  _grandPrixIdForeignKey: 3, 
  _lapTime: 96.050,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 4, 
  _grandPrixIdForeignKey: 3, 
  _lapTime: 96.200,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 5, 
  _grandPrixIdForeignKey: 3, 
  _lapTime: 96.500,
});


await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 1, 
  _grandPrixIdForeignKey: 4, 
  _lapTime: 94.200,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 2, 
  _grandPrixIdForeignKey: 4, 
  _lapTime: 94.350,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 3, 
  _grandPrixIdForeignKey: 4, 
  _lapTime: 94.500,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 4, 
  _grandPrixIdForeignKey: 4, 
  _lapTime: 94.650,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 5, 
  _grandPrixIdForeignKey: 4, 
  _lapTime: 94.950,
});


await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 1, 
  _grandPrixIdForeignKey: 5, 
  _lapTime: 85.900,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 2, 
  _grandPrixIdForeignKey: 5, 
  _lapTime: 86.050,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 3, 
  _grandPrixIdForeignKey: 5, 
  _lapTime: 86.200,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 4, 
  _grandPrixIdForeignKey: 5, 
  _lapTime: 86.350,
});
await db.insert(_driversPerformanceTable, {
  _driverIdForeignKey: 5, 
  _grandPrixIdForeignKey: 5, 
  _lapTime: 86.650,
});
},
    );

    return _database!; 
  }
}