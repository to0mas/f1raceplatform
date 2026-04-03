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
      onCreate: (db, version) => db.execute(



        '''
        CREATE TABLE $_grandprixTable(
          $_grandPrixId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_grandPrixName TEXT,
          $_grandPrixLaps INTEGER
        );


        CREATE TABLE $_driverTable(
          $_driverId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_driverFirstName TEXT,
          $_driverLastName TEXT
        );

        CREATE TABLE $_tiresTable(
          $_tireId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_tireCompound TEXT,
          $_degradation REAL
        );

        CREATE TABLE $_driversPerformanceTable(
          $_performanceId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_driverIdForeignKey INTEGER,
          $_grandPrixIdForeignKey INTEGER,
          $_lapTime REAL,
          $_DNF INTEGER,// bohuzel neni boolean v sqlite, takze pouzivame integer (0 = false, 1 = true)
          FOREIGN KEY ($_driverIdForeignKey) REFERENCES $_driverTable($_driverId),
          FOREIGN KEY ($_grandPrixIdForeignKey) REFERENCES $_grandprixTable($_grandPrixId)
        );


        '''
      ),
    );

    return _database!; 
  }
}