import 'package:flutter/material.dart';

import '../api_calls/driver_call.dart';
import '../api_calls/driver_standings_call.dart';
import '../api_calls/team_standings_call.dart';

import '../models/driver.dart';
import '../models/driver_standing.dart';
import '../models/team_standing.dart';

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  bool isLoading = true;
  bool showDrivers = true;

  List<Driver> drivers = [];
  List<DriverStanding> driverStandings = [];
  List<TeamStanding> teamStandings = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    drivers = await DriverCall().getDrivers();
    driverStandings = await DriverStandingsCall().getDriverStandings();
    teamStandings = await TeamStandingsCall().getTeamStandings();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
   
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tab("Drivers", showDrivers, () {
                      setState(() {
                        showDrivers = true;
                      });
                    }),
                    const SizedBox(width: 10),
                    _tab("Teams", !showDrivers, () {
                      setState(() {
                        showDrivers = false;
                      });
                    }),
                  ],
                ),

                const SizedBox(height: 20),
                

                Expanded(
                  child: ListView.builder(
                    itemCount: showDrivers
                        ? driverStandings.length
                        : teamStandings.length,
                    itemBuilder: (context, index) {
                      if (showDrivers) {
                        return driverCard(driverStandings[index], index);
                      } else {
                        return teamCard(teamStandings[index], index);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget driverCard(DriverStanding d, int index) {

    Driver? driver;

    try {
      driver = drivers.firstWhere(
        (x) => x.nameAcronym == d.driverCode,
      );
    } catch (e) {
      driver = null;
    }

    ImageProvider image =
        const AssetImage("assets/images/Logo_tr.png");

    if (driver != null &&
        driver.headshotUrl != null &&
        driver.headshotUrl!.isNotEmpty) {
      image = NetworkImage(driver.headshotUrl!);
    }

    return buildCard(
      index + 1,
      "${d.givenName} ${d.familyName}",
      d.driverCode,
      d.points.toString(),
      image,
    );
  }

  Widget teamCard(TeamStanding t, int index) {
    return buildCard(
      index + 1,
      t.teamName,
      t.teamCode,
      t.points.toString(),
      getTeamLogo(t.teamName, t.teamCode),
    );
  }

  ImageProvider getTeamLogo(String teamName, String teamCode) {

    String value = (teamName + teamCode).toLowerCase();

    if (value.contains("mercedes")) {
      return const AssetImage("assets/images/mercedes.png");
    }

    if (value.contains("ferrari")) {
      return const AssetImage("assets/images/ferrari.png");
    }

    if (value.contains("mclaren")) {
      return const AssetImage("assets/images/mclaren.png");
    }

    if (value.contains("haas")) {
      return const AssetImage("assets/images/haas.png");
    }

    if (value.contains("alpine")) {
      return const AssetImage("assets/images/alpine.png");
    }

    if (value.contains("red_bull")) {
      return const AssetImage("assets/images/redbull.png");
    }

    if (value.contains("rb")) {
      return const AssetImage("assets/images/rb.png");
    }

    if (value.contains("audi")) {
      return const AssetImage("assets/images/audi.png");
    }

    if (value.contains("williams")) {
      return const AssetImage("assets/images/williams.png");
    }

    if (value.contains("cadillac")) {
      return const AssetImage("assets/images/cadillac.png");
    }

    if (value.contains("aston_martin")) {
      return const AssetImage("assets/images/aston.png");
    }

    return const AssetImage("assets/images/Logo_tr.png");
  }

  Widget buildCard(
    int position,
    String title,
    String subtitle,
    String points,
    ImageProvider image,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            "$position",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundImage: image,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 2),
              ],
            ),
          ),
          Text(
            "$points pt",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromARGB(150, 197, 11, 11)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}