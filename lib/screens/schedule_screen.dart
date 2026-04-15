import 'dart:ui';

import 'package:f1raceplatform/api_calls/schedule_call.dart';
import 'package:f1raceplatform/models/schedule.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Schedule> schedule = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    schedule = await ScheduleCall().getSchedule();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
appBar: AppBar(
  backgroundColor: Colors.transparent,
  
  automaticallyImplyLeading: false,

  flexibleSpace: ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        decoration: BoxDecoration(
         
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
      ),
    ),
  ),

  title: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Center(
      child: Image.asset(
        'assets/images/Logo_tr_cerna.png',
        height: 50,
        width: 45,
      ),
    ),
  ),
),
  

    body: ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: schedule.length,
  itemBuilder: (context, index) {
    final item = schedule[index];

    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 51, 51, 49),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.meetingOfficialName),
            Text(item.circuitShortName),
            Text(item.dateStart.toString()),
          ],
        ),
      ),
    );
  },
),
    );
  }
}