import 'package:flutter/material.dart';
import 'package:f1raceplatform/theme/theme_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: appTheme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(Color(0xFF1A1A1A).value),
        showSelectedLabels: false,
  showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
            color: Color(0xFFE10600),
            ),
            label: '', 
            
          ),
          BottomNavigationBarItem(
            icon: Image(image:  NetworkImage('https://cdn-icons-png.flaticon.com/512/25/25694.png')),
            label: '', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '', 
          ),
        ],
      ),
    );
  }
}