import 'package:flutter/material.dart';
import '../models/driver.dart';

class HamiltonScreen extends StatelessWidget {
  final Driver driver;

  const HamiltonScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driver.nameAcronym),
      ),
      body: Center(
        child: Text(driver.nameAcronym),
      ),
    );
  }
}