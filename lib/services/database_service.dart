import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance =
      DatabaseService._privateConstructor();
  static Database? _database;

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
          CREATE TABLE grandprix(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            grandprix_name TEXT UNIQUE NOT NULL,
            laps INTEGER NOT NULL,
            base_lap_time REAL DEFAULT 80.0
          )
        ''');

        await db.execute('''
          CREATE TABLE drivers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            driver_first_name TEXT NOT NULL,
            driver_last_name TEXT NOT NULL,
            team TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE tires(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tire_compound TEXT UNIQUE NOT NULL,
            degradation REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE drivers_performance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            driver_id INTEGER NOT NULL,
            grandprix_id INTEGER NOT NULL,
            lap_time REAL,
            total_time REAL NOT NULL,
            FOREIGN KEY(driver_id) REFERENCES drivers(id),
            FOREIGN KEY(grandprix_id) REFERENCES grandprix(id),
            UNIQUE(driver_id, grandprix_id)
          )
        ''');

      
        await db.insert('grandprix', {
          'grandprix_name': 'Bahrain Grand Prix',
          'laps': 57,
          'base_lap_time': 80.0,
        });

        await db.insert('grandprix', {
          'grandprix_name': 'Australian Grand Prix',
          'laps': 58,
          'base_lap_time': 81.5,
        });

        await db.insert('grandprix', {
          'grandprix_name': 'Japanese Grand Prix',
          'laps': 53,
          'base_lap_time': 82.0,
        });

        await db.insert('grandprix', {
          'grandprix_name': 'British Grand Prix',
          'laps': 52,
          'base_lap_time': 79.0,
        });

        await db.insert('grandprix', {
          'grandprix_name': 'Italian Grand Prix',
          'laps': 53,
          'base_lap_time': 78.5,
        });

        // 🏎️ DRIVERS
        await db.insert('drivers', {
          'driver_first_name': 'Max',
          'driver_last_name': 'Verstappen',
          'team': 'Red Bull',
        });

        await db.insert('drivers', {
          'driver_first_name': 'Lando',
          'driver_last_name': 'Norris',
          'team': 'McLaren',
        });

        await db.insert('drivers', {
          'driver_first_name': 'Charles',
          'driver_last_name': 'Leclerc',
          'team': 'Ferrari',
        });

        await db.insert('drivers', {
          'driver_first_name': 'George',
          'driver_last_name': 'Russell',
          'team': 'Mercedes',
        });

        await db.insert('drivers', {
          'driver_first_name': 'Fernando',
          'driver_last_name': 'Alonso',
          'team': 'Aston Martin',
        });

        // 🛞 TIRES (🔥 FIX: SNÍŽENÁ DEGRADACE)
        await db.insert('tires', {
          'tire_compound': 'Soft',
          'degradation': 0.035, // ↓ z 0.05
        });

        await db.insert('tires', {
          'tire_compound': 'Medium',
          'degradation': 0.028, // ↓ z 0.04
        });

        await db.insert('tires', {
          'tire_compound': 'Hard',
          'degradation': 0.020, // ↓ z 0.03
        });

        await db.insert('tires', {
          'tire_compound': 'Intermediate',
          'degradation': 0.025,
        });

        await db.insert('tires', {
          'tire_compound': 'Full Wet',
          'degradation': 0.030,
        });

       
        await db.insert('drivers_performance', {
          'driver_id': 1,
          'grandprix_id': 1,
          'total_time': 4550.0,
        });

        await db.insert('drivers_performance', {
          'driver_id': 2,
          'grandprix_id': 1,
          'total_time': 4555.0,
        });

        await db.insert('drivers_performance', {
          'driver_id': 3,
          'grandprix_id': 1,
          'total_time': 4560.0,
        });

        await db.insert('drivers_performance', {
          'driver_id': 4,
          'grandprix_id': 1,
          'total_time': 4545.0,
        });

        await db.insert('drivers_performance', {
          'driver_id': 5,
          'grandprix_id': 1,
          'total_time': 4565.0,
        });
      },
    );

    return _database!;
  }

  Future<double> getExpectedTime(int driverId, int gpId) async {
    final db = await getDatabase();

    final result = await db.query(
      'drivers_performance',
      where: 'driver_id = ? AND grandprix_id = ?',
      whereArgs: [driverId, gpId],
    );

    if (result.isEmpty) return 0;

    return (result.first['total_time'] as num).toDouble();
  }

  Future<List<Map<String, dynamic>>> getGrandPrix() async {
    final db = await getDatabase();
    return db.query('grandprix');
  }

  Future<List<Map<String, dynamic>>> getDrivers() async {
    final db = await getDatabase();
    return db.query('drivers');
  }

  Future<List<Map<String, dynamic>>> getTires() async {
    final db = await getDatabase();
    return db.query('tires');
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}