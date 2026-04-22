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
      version: 3, // zvýšená verze
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertSeedData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // během vývoje jednoduše smažeme vše a vytvoříme znovu
        await db.execute('DROP TABLE IF EXISTS drivers_performance');
        await db.execute('DROP TABLE IF EXISTS tires');
        await db.execute('DROP TABLE IF EXISTS drivers');
        await db.execute('DROP TABLE IF EXISTS grandprix');

        await _createTables(db);
        await _insertSeedData(db);
      },
    );

    return _database!;
  }

  Future<void> _createTables(Database db) async {
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
        team TEXT,
        wins INTEGER DEFAULT 0,
        podiums INTEGER DEFAULT 0,
        points INTEGER DEFAULT 0
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
  }

  Future<void> _insertSeedData(Database db) async {
    // GRAND PRIX
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

    // DRIVERS
    await db.insert('drivers', {
      'driver_first_name': 'Max',
      'driver_last_name': 'Verstappen',
      'team': 'Red Bull',
      'wins': 56,
      'podiums': 98,
      'points': 2500,
    });

    await db.insert('drivers', {
      'driver_first_name': 'Lando',
      'driver_last_name': 'Norris',
      'team': 'McLaren',
      'wins': 6,
      'podiums': 25,
      'points': 900,
    });

    await db.insert('drivers', {
      'driver_first_name': 'Charles',
      'driver_last_name': 'Leclerc',
      'team': 'Ferrari',
      'wins': 5,
      'podiums': 30,
      'points': 1100,
    });

    await db.insert('drivers', {
      'driver_first_name': 'George',
      'driver_last_name': 'Russell',
      'team': 'Mercedes',
      'wins': 2,
      'podiums': 15,
      'points': 700,
    });

    await db.insert('drivers', {
      'driver_first_name': 'Fernando',
      'driver_last_name': 'Alonso',
      'team': 'Aston Martin',
      'wins': 32,
      'podiums': 100,
      'points': 2100,
    });

    // TIRES (žádné duplicity)
    await db.insert('tires', {'tire_compound': 'Soft', 'degradation': 0.035});
    await db.insert('tires', {'tire_compound': 'Medium', 'degradation': 0.028});
    await db.insert('tires', {'tire_compound': 'Hard', 'degradation': 0.020});
    await db.insert('tires', {'tire_compound': 'Intermediate', 'degradation': 0.015});
    await db.insert('tires', {'tire_compound': 'Full Wet', 'degradation': 0.012});
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}